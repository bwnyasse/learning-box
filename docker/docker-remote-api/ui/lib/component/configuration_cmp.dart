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

@Component(
    selector: 'configuration-cmp',
    templateUrl:
    'packages/bw_dra/component/configuration_cmp.html',
    useShadowDom: false)
class ConfigurationCmp extends ShadowRootAware {

  DockerRemoteControler controler;
  DockerRemoteConnection connection;
  String version;
  String info;

  String stats;
  var ctx;
  ConfigurationCmp(this.controler);

  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
    initConnection();
  }

  initConnection() async {
    connection = await controler.load(Uri.parse('http://192.168.1.19:2375'));
    ctx = (querySelector('#canvas') as CanvasElement).context2D;
  }

  handleVersion() async {
    VersionResponse versionResponse = await connection.version();
    version =  versionResponse._asPrettyJson;
  }

  handleInfo() async {
    InfoResponse infoResponse = await connection.info();
    info = infoResponse._asPrettyJson;
  }

  handleStats() async {

    connection._requestStream2();
//    final Stream<StatsResponse> stream =
//    connection.stats(new Container("1e9410a73aed"),stream: false).take(5);
//
//    final List<StatsResponse> items =  await stream.toList();
//    for (final item in items) {
//      print(item._asPrettyJson);
//    }

  }

  void showChart() {

    var rnd = new math.Random();
    var months = <String>["January", "February", "March", "April", "May", "June"];

    var data = new LinearChartData(labels: months, datasets: <ChartDataSets>[
      new ChartDataSets(
          label: "My First dataset",
          backgroundColor: "rgba(220,220,220,0.2)",
          data: months.map((_) => rnd.nextInt(100)).toList()),
      new ChartDataSets(
          label: "My Second dataset",
          backgroundColor: "rgba(151,187,205,0.2)",
          data: months.map((_) => rnd.nextInt(100)).toList())
    ]);

    var config = new ChartConfiguration(
        type: 'line', data: data, options: new ChartOptions(responsive: true));

    new Chart(ctx, config);
  }

  Future<int> sumStream(Stream<StatsResponse> stream) async {
    var sum = 0;
    await for (var value in stream) {
      print(value);
      sum = sum++;
    }
    return sum;
  }
}