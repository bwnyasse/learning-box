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

  ConfigurationCmp(this.controler);

  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
    initConnection();
  }

  initConnection() async {
    connection = await controler.load(Uri.parse('http://192.168.1.19:2375'));
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

    final Stream<StatsResponse> stream =
    connection.stats(new Container("1e9410a73aed")).take(5);

    await sumStream(stream);


//    final List<StatsResponse> items =  stream.;
//    for (final item in items) {
//      print(item._asPrettyJson);
//    }

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