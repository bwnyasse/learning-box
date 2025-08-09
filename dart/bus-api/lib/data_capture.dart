import 'dart:io';
import 'package:datetime/datetime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart' as xml;
import 'package:decimal/decimal.dart';
import 'package:shapely/shapely.dart';
import 'package:geopandas/geopandas.dart';
import 'package:pandas/pandas.dart';
import 'package:googleapis/storage/v1.dart' as storage;
import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/src/crypto/rsa.dart';
import 'package:path/path.dart' as p;

final storage_client = storage.StorageApi(authClient);

Future<String> actual_prefix() async {
  final hoy = DateTime.now();
  final current_date_str = hoy.format("Y/m/d");
  return current_date_str;
}

Future<List<storage.Object>> list_blobs(
    String bucket_name, String prefix, storage.StorageApi storage_client,
    {String type = "file"}) async {
  final max_results = type == "file" ? null : 1;
  final response = await storage_client.objects.list(bucket_name,
      prefix: prefix, maxResults: max_results);

  if (response.items != null) {
    return response.items!;
  }

  return [];
}

Future<String> savePredictionsData(
    String bucket_name,
    String blob_name_csv,
    String blob_name_json,
    storage.StorageApi google_client,
    DataFrame df,
    {String prefix = ""}) async {
  try {
    final bucket = bucket_name;
    final blob_csv = prefix + blob_name_csv;
    final blob_json = prefix + blob_name_json;

    final jsonContent = df.toJSON(orient: "records");

    final mediaType = MediaType("application", "json");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "https://storage.googleapis.com/upload/storage/v1/b/$bucket/o",
      ),
    );

    request.headers["Content-Type"] = "multipart/form-data";

    request.fields["name"] = blob_json;
    request.fields["uploadType"] = "media";
    request.fields["predefinedAcl"] = "publicRead";

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        utf8.encode(jsonContent),
        filename: p.basename(blob_json),
        contentType: mediaType,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      return blob_json;
    } else {
      throw "Error saving predictions on bucket $bucket_name";
    }
  } catch (e) {
    throw "Error saving predictions on bucket $bucket_name : $e";
  }
}

Future<Uint8List> readGTFSData(
    String bucket_name,
    String blob_name,
    String content_name,
    storage.StorageApi google_client,
    {String prefix = ""}) async {
  try {
    final bucket = bucket_name;
    final blob = prefix + blob_name;

    final response = await google_client.objects.get(bucket, blob);
    final bytes = response.downloadOptions.rawDownload;

    final flo = bytes as ByteData;

    final zipedFiles = ZipDecoder().decodeBuffer(flo.buffer.asUint8List());

    final zipFile = ZipFileEncoder();

    zipFile.open(format: ZipFileFormat.ZIP, filename: blob);
    zipFile.addFile(zipedFiles);
    zipFile.close();

    final unzippedFileBytes = zipedFiles.first.content as List<int>;
    return Uint8List.fromList(unzippedFileBytes);
  } catch (e) {
    throw "Error reading GTFS file content for $content_name : file not found into $blob_name";
  }
}

Future<xml.XmlElement> netBusDataRequest(
    String base_url, Map<String, dynamic> kwargs) async {
  final headers = {"Content-Type": "text/xml"};
  if (kwargs.containsKey("key")) {
    // create security header if needed
    // headers["Authorization"] = kwargs['key'];
  }

  final uri = Uri.parse(base_url).replace(queryParameters: kwargs);
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    final responseBody = response.body;
    final document = xml.XmlDocument.parse(responseBody);

    final errorElements = document.findAllElements("Error");
    if (errorElements.isNotEmpty) {
      final shouldRetry = errorElements.first.getAttribute("shouldRetry");

      if (shouldRetry == "true") {
        throw errorElements.first.text;
      } else {
        throw errorElements.first.text;
      }
    }

    return document.rootElement;
  } else {
    throw "Error query API : ${response.body}";
  }
}

Future<String> saveGCPData(
    String bucket_name,
    String blob_name,
    storage.StorageApi google_client,
    Uint8List content,
    {String prefix = ""}) async {
  try {
    final bucket = bucket_name;
    final blob = prefix + blob_name;

    final mediaType = MediaType("application", "octet-stream");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "https://storage.googleapis.com/upload/storage/v1/b/$bucket/o",
      ),
    );

    request.headers["Content-Type"] = "multipart/form-data";

    request.fields["name"] = blob;
    request.fields["uploadType"] = "media";
    request.fields["predefinedAcl"] = "publicRead";

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        content,
        filename: p.basename(blob),
        contentType: mediaType,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      return blob;
    } else {
      throw "Error saving data in bucket $bucket_name";
    }
  } catch (e) {
    throw "Error saving data in bucket $bucket_name : $e";
  }
}

String isDeparture(Map<String, dynamic> x) {
  final prev_line =
      x['prev_stop_geo'] != null ? LineString([x['geo'], x['prev_stop_geo']]) : null;
  final next_line =
      x['next_stop_geo'] != null ? LineString([x['geo'], x['next_stop_geo']]) : null;
  final prev_projection =
      prev_line != null ? prev_line.project(x['geo_vid'], normalized: true) : 0.0;
  final next_projection =
      next_line != null ? next_line.project(x['geo_vid'], normalized: true) : 0.0;
  return next_projection > 0 ? 'departure' : 'arrival';
}

Tuple2<Point, Point> prev_next_stop(Map<String, dynamic> x,
    {required Map<String, List<dynamic>> dictGeographic}) {
  Point? prev_stop_geo;
  Point? next_stop_geo;

  try {
    if (x['sequence'] == 1) {
      prev_stop_geo = null;
    } else {
      prev_stop_geo = dictGeographic[x['direction']]![x['sequence'] - 2];
    }
  } catch (e) {
    prev_stop_geo = null;
  }

  try {
    next_stop_geo = dictGeographic[x['direction']]![x['sequence']];
  } catch (e) {
    next_stop_geo = null;
  }

  return Tuple2(prev_stop_geo, next_stop_geo);
}

Tuple2<dynamic, dynamic> origin_and_destination(Map<String, dynamic> x,
    {required Map<String, dynamic> dictOrigin,
    required Map<String, dynamic> dictDestination}) {
  final origin = dictOrigin[x['direction']];
  final destination = dictDestination[x['direction']];
  return Tuple2(origin, destination);
}

DataFrame gcp_csv_to_df(
    String bucket_name, String source_file_name, storage.StorageApi storage_client,
    {String prefix = ""}) {
  final bucket = bucket_name;
  final blob = prefix + source_file_name;

  final response = storage_client.objects.get(bucket, blob);
  final bytes = response.downloadOptions.rawDownload;

  final flo = bytes as ByteData;

  final data = flo.buffer.asUint8List();

  final df = DataFrame.fromCsv(Uint8List.fromList(data));

  return df;
}

bool new_departure(Map<String, dynamic> x) {
  if (x['next_type'] == null) {
    return false;
  } else if (x['next_type'][0] == 'departure' && x['next_type'][1] == x['station']) {
    return false;
  } else {
    return true;
  }
}

bool new_arrival(Map<String, dynamic> x) {
  if (x['prev_type'] == null) {
    return false;
  } else if (x['prev_type'][0] == 'arrival' && x['prev_type'][1] == x['station']) {
    return false;
  } else {
    return true;
  }
}

void main(List<String> args) async {
  final gtfsfiles = "gtfs_dictionaries.zip";
  final bucket_name_source = "gus-ttc-gtfs-poc";
  final bucket_name_destination = "ttc_enzo_test";
  var month = "06";

  if (args.isNotEmpty) {
    month = args[0];
  }

  //Set variables
  final prefix = '2023/$month';
  final prefixOutput = "aproximation/";
  final dict_directions = "$prefixOutput/stopsByDir.csv";
  final fileScope = RegExp(r"backup_for_[0-9]+");
  final route = 165;
  final base_url = "https://webservices.umoiq.com/service/publicXMLFeed";
  var last_time = 0;
  final agent = "ttc";
  final virtualFile = StringBuffer();
  virtualFile.write("filesource, error, date");
  final mappingDir = {"EAST": "Eastbound", "WEST": "Westbound"};
  final busList = [8930, 8929, 8911, 8927, 8917, 8925, 8938, 8907, 8921, 8924, 8900];

  //Read input
  print("Reading input ${DateTime.now()}");

  final googleFiles = await list_blobs(
    bucket_name_destination,
    "$prefixOutput$month",
    storage_client,
  );
  for (final file in googleFiles) {
    final df = gcp_csv_to_df(bucket_name_destination, file.name, storage_client);
    final bus = df.at(0, 'vid');
    //drop unnecesary data
    df.drop(df.filter(df['vid'].isIn(busList)).rows, inplace: true);
    //find duplicated trips
    df['tmstmp'] = df['tmstmp'].parse<DateTime>();
    df['date'] = df['tmstmp'].map((date) => date.date);
    final duplicatedSeries = df.groupby(["tatripid"])["date"].nunique();

    df.drop(df.filter(
      df['tatripid'].isIn(duplicatedSeries.filter((value) => value != 1).index.toList()),
    ).rows, inplace: true);
    final dir = RegExp(r"([A-Z]{0,4})\s");
    df['direction'] = df.apply(
      (x) => (dir.firstMatch(x['des'])?.group(1)?.trim())?.map(mappingDir),
      axis: 1,
    );
    final directions_df = gcp_csv_to_df(
      bucket_name_destination,
      dict_directions,
      storage_client,
    );
    directions_df['sequence'] = directions_df.groupby('DIRECTION').cumcount() + 1;

    //Services and stops
    print("Reading dictionaries ${DateTime.now()}");

    final content_name = "stops.txt";
    final stopsGeo = {
      for (final line in await readGTFSData(
          bucket_name_destination, gtfsfiles, content_name, storage_client, prefixOutput))
        int.parse(line.decode('utf-8').split(',')[1]):
            Point(Decimal.parse(line.decode('utf-8').split(',')[5]), Decimal.parse(line.decode('utf-8').split(',')[4]))
    };
    directions_df['geo'] = directions_df.apply(
      (x) => stopsGeo[x['STOP']],
      axis: 1,
    );

    final dictGeographic = {
      for (final group in directions_df.sort('sequence').groupBy('DIRECTION')['geo'])
        group.key: group.toList()
    };

    final dictStop = {
      for (final group in directions_df.sort('sequence').groupBy('DIRECTION')['STOP'])
        group.key: group.toList()
    };

    final destinations = directions_df.groupby('DIRECTION')['STOP'].last().toDict();
    final origins = directions_df.groupby('DIRECTION')['STOP'].first().toDict();

    final content_name = "routes.txt";
    final route_id = (await readGTFSData(
            bucket_name_destination, gtfsfiles, content_name, storage_client, prefixOutput))
        .firstWhere((line) => line.decode('utf-8').split(',')[2] == route.toString())
        .decode('utf-8')
        .split(',')[0];
    final content_name = "trips.txt";
    final service_id = (await readGTFSData(
            bucket_name_destination, gtfsfiles, content_name, storage_client, prefixOutput))
        .where((line) => line.decode('utf-8').split(',')[0] == route_id)
        .map((line) => Tuple2(
              line.decode('utf-8').split(',')[1],
              int.parse(line.decode('utf-8').split(',')[2]),
            ))
        .toList();
    final defaultService = service_id.first;

    //Prepare data output
    print("Making computations ${DateTime.now()}");

    final output_df = df.sort(['vid', 'tmstmp']);
    output_df['geo_vid'] = output_df.apply(
      (x) => Point(Decimal.parse(x['lon']), Decimal.parse(x['lat'])),
      axis: 1,
    );
    output_df = directions_df.crossJoin(output_df).sort(['vid', 'tmstmp']);
    output_df = output_df.filter(output_df['DIRECTION'] == output_df['direction']);

    //Make computations
    print("Making computations ${DateTime.now()}");

    output_df['distances'] = output_df.apply(
      (x) => x['geo'].distance(x['geo_vid']),
      axis: 1,
    );
    final group_near = output_df.groupby(['vid', 'tatripid', 'tmstmp'])['distances'].idxmin();
    output_df['nearest'] = false;
    output_df.loc[group_near, 'nearest'] = true;
    output_df = output_df.filter(output_df['nearest'] == true);
    //Clean
    output_df.drop(columns: [
      'pdist',
      'pid',
      'hdg',
      'lat',
      'lon',
      'distances',
      'ROUTE',
      'DIRECTION',
      'DESCRIPTION',
      'Unnamed: 0',
      'blk',
      'nearest',
    ], inplace: true);
    //Drop duplicated stops
    output_df.dropDuplicates(subset: ['vid', 'tatripid', 'STOP'], keep: 'first', inplace: true);
    output_df['next_sequence'] = output_df[['vid', 'tatripid', 'sequence']]
        .groupby(['vid', 'tatripid'])['sequence']
        .shift(-1)
        .astype('Int64');
    output_df['prev_sequence'] = output_df[['vid', 'tatripid', 'sequence']]
        .groupby(['vid', 'tatripid'])['sequence']
        .shift(1)
        .astype('Int64');
    output_df.resetIndex(drop: true, inplace: true);
    final s = output_df.index.series();
    output_df['next_index'] = s.shift(-1);
    output_df['prev_index'] = s.shift(1);

    //Drop stops out of route configurations
    output_df['prev_sequence'] = output_df['prev_sequence'].fillna(0);
    output_df.drop(output_df.filter(
      output_df['next_sequence'] < output_df['sequence'],
    ).apply(
      (x) => x.index if x['next_sequence'] > x['prev_sequence'] else x['next_index'],
      axis: 1,
    ).index,
        inplace: true);
    //Reset next sequence attribute
    output_df['next_sequence'] = output_df[['vid', 'tatripid', 'sequence']]
        .groupby(['vid', 'tatripid'])['sequence']
        .shift(-1)
        .astype('Int64');
    //Complete the final stop
    output_df.loc[
        (output_df['next_sequence'].isNull()) &
            (output_df['STOP'] != dictStop[output_df['direction']][-1]),
        'next_sequence'] =
        output_df.loc[(output_df['next_sequence'].isNull())].apply(
            (x) => (dictStop[x['direction']].length + 1) != x['next_sequence'],
            axis: 1);

    output_df['next_time'] = output_df[['vid', 'tatripid', 'tmstmp']]
        .groupby(['vid'])['tmstmp']
        .shift(-1);
    output_df['accuracy'] = 1;
    output_df[['prev_stop_geo', 'next_stop_geo']] = output_df.apply(
      (x) => prev_next_stop(x, dictGeographic: dictGeographic),
      axis: 1,
    ).series();
    output_df['type'] = output_df.apply(
      isDeparture,
      axis: 1,
    );
    output_df.drop(columns: ['geo', 'prev_stop_geo', 'next_stop_geo', 'geo_vid'], inplace: true);
    output_df['tatripid'] = output_df['tatripid'].astype('int64');

    final df_fill = output_df.filter(
      (output_df['next_sequence'] - output_df['sequence'] > 1) &
          (output_df['next_time'].notNull()),
    );

    df_fill['time_diff'] = (df_fill['next_time'].parse<DateTime>() - df_fill['tmstmp'].parse<DateTime>())
        .dt.totalSeconds
        .astype('Int64');
    df_fill['stop_pending'] = (df_fill['next_sequence'] - df_fill['sequence']).astype('int');
    final new_row = <Map<String, dynamic>>[];
    for (final row in df_fill.iterrows) {
      for (var i = 0; i < row['stop_pending'] - 1; i++) {
        final counter = i + 1;
        final new_sequence = row['sequence'] + counter;
        final new_time =
            row['tmstmp'].parse<DateTime>() + Duration(seconds: (row['time_diff'] / row['stop_pending']) * counter);
        final new_STOP = dictStop[row['direction']][new_sequence - 1];
        new_row.add({
          "STOP": new_STOP,
          "sequence": new_sequence,
          'vid': row['vid'],
          'tmstmp': new_time,
          'spd': row['spd'],
          'tatripid': row['tatripid'],
          'des': row['des'],
          'direction': row['direction'],
          "accuracy": 0,
          "type": "departure",
        });
      }
    }

    output_df.drop(columns: [
      'prev_sequence',
      'next_index',
      'prev_index',
      'next_sequence',
      'next_time',
      'date',
    ], inplace: true);
    output_df.append(new_row, ignoreIndex: false).sort(['vid', 'tmstmp']);

    output_df[['origin', 'destination']] = output_df.apply(
      (x) => origin_and_destination(
        x,
        dictOrigin: origins,
        dictDestination: destinations,
      ),
      axis: 1,
    ).series();
    output_df.rename(
      columns: {
        'tatripid': 'trip',
        'vid': 'carriageId',
        'STOP': 'station',
        'tmstmp': 'time',
      },
      inplace: true,
    );
    output_df['service'] = defaultService;

    //Save data
    print("Saving data ${DateTime.now()}");

    //filter data
    final df = output_df[
        ['time', 'type', 'trip', 'carriageId', 'origin', 'destination', 'station', 'service', 'sequence', 'direction', 'accuracy']];
    //drop duplicated data
    //df.dropDuplicates(subset=['type','trip','station'], keep='last', inplace=True);

    //fill dummy
    df['next_type'] = df[['type', 'station']].apply(
      (x) => Tuple2(x['type'], x['station']),
      axis: 1,
    ).shift(-1);
    df['prev_type'] = df[['type', 'station']].apply(
      (x) => Tuple2(x['type'], x['station']),
      axis: 1,
    ).shift(1);

    df['next_time'] = df['time'].shift(-1).parse<DateTime>();
    df['prev_time'] = df['time'].shift(1).parse<DateTime>();

    final df_new_record_departue = df.filter(
      (df['type'] == 'arrival') &
          df.apply(
            new_departure,
            axis: 1,
          ) &
          (df['destination'] != df['station']),
    );
    df_new_record_departue['type'] = 'departure';
    final df_new_record_arrival = df.filter(
      (df['type'] == 'departure') &
          df.apply(
            new_arrival,
            axis: 1,
          ) &
          (df['origin'] != df['station']),
    );
    df_new_record_arrival['type'] = 'arrival';
    //Clean
    df.drop(columns: ['prev_type', 'next_type'], inplace: true);
    df_new_record_departue.drop(columns: ['prev_type', 'next_type'], inplace: true);
    df_new_record_arrival.drop(columns: ['prev_type', 'next_type'], inplace: true);
    df_new_record_departue['accuracy'] = 0;
    df_new_record_arrival['accuracy'] = 0;

    df_new_record_departue['time'] = df_new_record_departue.apply(
      (x) => x['time'].parse<DateTime>() + (x['next_time'].parse<DateTime>() - x['time'].parse<DateTime>()) / 2,
      axis: 1,
    );
    df_new_record_arrival['time'] = df_new_record_arrival.apply(
      (x) => x['time'].parse<DateTime>() - (x['time'].parse<DateTime>() - x['prev_time'].parse<DateTime>()) / 2,
      axis: 1,
    );

    df.concat([df_new_record_departue, df_new_record_arrival], ignoreIndex: true).sort('time');

    df.sort(['carriageId', 'time'], inplace: true);
    df.drop(columns: ['prev_time', 'next_time'], inplace: true);
    df['time'] = df.apply((x) => x['time'].toIso8601String(), axis: 1);

    final blob_name_csv = "aproximation_type_for_$bus.csv";
    final blob_name_json = "aproximation_type_for_$bus.json";
    final url = savePredictionsData(
      bucket_name_destination,
      blob_name_csv,
      blob_name_json,
      storage_client,
      df,
      '$prefixOutput$month/',
    );

    storage_client.close();
  }
}
