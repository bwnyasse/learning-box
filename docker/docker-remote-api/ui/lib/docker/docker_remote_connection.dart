/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 30/09/16
 * Author     : bwnyasse
 *  
 */
part of bw_dra;

class DockerRemoteConnection extends AbstractHttpService {

  String hostServer;

  DockerRemoteConnection(this.hostServer);

  VersionResponse _dockerVersion;
  VersionResponse get dockerVersion => _dockerVersion;

  String get apiVersion {
    if (dockerVersion == null) {
      return null;
    }
    return dockerVersion.apiVersion;
  }

  /// Loads the version information from the Docker service.
  /// The version information is used to adapt to differences in the Docker
  /// remote API between different Docker version.
  /// If [init] isn't called no version specific handling can be done.
  Future init() async {
    if (_dockerVersion == null) {
      _dockerVersion = await version();
    }
  }

  /// Show Docker version information.
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Future<VersionResponse> version() async {
    String url = hostServer + '/version';
    var response = await _get(url);
    Map jsonResponse = JSON.decode(response.responseText);
    return new VersionResponse.fromJson(jsonResponse);
  }

  /// Get system-wide information.
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Future<InfoResponse> info() async {
    String url = hostServer + '/info';
    var response = await _get(url);
    Map jsonResponse = JSON.decode(response.responseText);
    return new InfoResponse.fromJson(jsonResponse);
  }

  /// Get container events from docker, either in real time via streaming, or
  /// via polling (using since).
  /// Docker containers will report the following events:
  ///     create, destroy, die, exec_create, exec_start, export, kill, oom,
  ///     pause, restart, start, stop, unpause
  ///   and Docker images will report:
  ///      untag, delete
  ///
  /// [since] Timestamp used for polling
  /// [until] Timestamp used for polling
  /// [filters] A json encoded value of the filters (a map[string][]string) to
  ///     process on the event list. Available filters:
  ///         event=<string> - event to filter
  ///         image=<string> - image to filter
  ///         container=<string> - container to filter
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Stream<EventsResponse> events(
      {DateTime since, DateTime until, EventsFilter filters}) async* {
    Map<String, String> query = {};
    if (since != null) query['since'] =
        (since.toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    if (until != null) query['until'] =
        (until.toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    if (filters != null) query['filters'] = JSON.encode(filters.toJson());

    print("LA ");
    String url = hostServer + '/events';
    var response = await _get(url);
//
//    final response =
//    await _requestStream(RequestType.get, '/events', query: query);
    //Map jsonResponse = JSON.decode(response.responseText);
    print("ICI " + response);
    if (response != null) {
      await for (var e in response) {
      print(UTF8.decode(e));
        yield new EventsResponse.fromJson(
            JSON.decode(UTF8.decode(e)));
      }
    }
  }


  /// Post request expecting a streamed response.
  Future<Stream> _requestStream(RequestType requestType, String path, {Map body,
  Map<String, String> query, Map<String, String> headers}) async {
    assert(requestType != null);
    assert(requestType == RequestType.post || body == null);

    String data;
    if (body != null) {
      data = JSON.encode(body);
    }
   // final url = serverReference.buildUri(path, query);
    final url =  hostServer + '/events';
    final request = new http.Request(requestType.toString(), Uri.parse(url))
      ..headers.addAll(headers != null ? headers : headersJson);
    if (data != null) {
      request.body = data;
    }
    final http.BaseResponse response = await request.send();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw new DockerRemoteApiError(
          response.statusCode, response.reasonPhrase, null);
    }
    return (response as http.StreamedResponse).stream;
  }
}

final Map headersJson = {'Content-Type': 'application/json'};
final Map headersTar = {'Content-Type': 'application/tar'};

class ServerReference {
  final Uri uri;
  http.Client client;
  ServerReference(this.uri, [this.client]);
  Uri buildUri(String path, Map<String, String> queryParameters) {
    return new Uri(
        scheme: uri.scheme,
        userInfo: uri.userInfo,
        host: uri.host,
        port: uri.port,
        path: path,
        queryParameters: queryParameters);
  }
}

/// Error thrown
class DockerRemoteApiError {
  final int statusCode;
  final String reason;
  final String body;

  DockerRemoteApiError(this.statusCode, this.reason, this.body);

  @override
  String toString() =>
      '${super.toString()} - StatusCode: ${statusCode}, Reason: ${reason}, Body: ${body}';
}

class RequestType {
  static const post = const RequestType('POST');
  static const get = const RequestType('GET');
  static const delete = const RequestType('DELETE');

  final String value;

  const RequestType(this.value);

  @override
  String toString() => value;
}