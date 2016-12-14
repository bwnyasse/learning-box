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
    ctx = (querySelector('#cpu-stats-chart') as CanvasElement).context2D;
  }

  handleVersion() async {
    VersionResponse versionResponse = await connection.version();
    version = versionResponse._asPrettyJson;
  }

  handleInfo() async {
    InfoResponse infoResponse = await connection.info();
    info = infoResponse._asPrettyJson;
  }

  handleStats() async {
    _requestStream2();
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
    var months = <String>["January", "February", "March", "April", "May", "June"
    ];

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

  void showCpuUsage() {
  }


  Future<int> sumStream(Stream<StatsResponse> stream) async {
    var sum = 0;
    await for (var value in stream) {
      print(value);
      sum = sum++;
    }
    return sum;
  }

//  updateCpuChart(data) {
//    var cpuChart;
//    cpuChart.addData([calculateCPUPercent(data)], new Date(data.read).toLocaleTimeString());
//    cpuChart.removeData();
//  }
//
//  calculateCPUPercent(stats) {
//    // Same algorithm the official client uses: https://github.com/docker/docker/blob/master/api/client/stats.go#L195-L208
//    var prevCpu = stats.precpu_stats;
//    var curCpu = stats.cpu_stats;
//
//    var cpuPercent = 0.0;
//
//    // calculate the change for the cpu usage of the container in between readings
//    var cpuDelta = curCpu.cpu_usage.total_usage - prevCpu.cpu_usage.total_usage;
//    // calculate the change for the entire system between readings
//    var systemDelta = curCpu.system_cpu_usage - prevCpu.system_cpu_usage;
//
//    if (systemDelta > 0.0 && cpuDelta > 0.0) {
//      cpuPercent = (cpuDelta / systemDelta) * curCpu.cpu_usage.percpu_usage.length * 100.0;
//    }
//    return cpuPercent;
//  }

  cpuPercent(StatsResponse statsResponse) {
    // Same algorithm the official client uses: https://github.com/docker/docker/blob/master/api/client/stats.go#L195-L208
    StatsResponseCpuStats preCpu = statsResponse.preCpuStats;
    StatsResponseCpuStats curCpu = statsResponse.cpuStats;

    var cpuPercent = 0.0;

    // calculate the change for the cpu usage of the container in between readings
    var cpuDelta = curCpu.cupUsage.totalUsage - preCpu.cupUsage.totalUsage;
    // calculate the change for the entire system between readings
    var systemDelta = curCpu.systemCpuUsage - preCpu.systemCpuUsage;
    if (systemDelta > 0.0 && cpuDelta > 0.0) {
      cpuPercent = (cpuDelta / systemDelta) * curCpu.cupUsage.perCpuUsage.length * 100.0;
    }
    return cpuPercent;
  }

  _requestStream2() {
    ResponseStream stream = new ResponseStream();
    stream.flow.listen((String data) {
      try {
        Map json = JSON.decode(data);
        StatsResponse statsResponse = new StatsResponse.fromJson(json, null);
        String readS = statsResponse.read.toLocal().toString();
        String cpuPercentS = cpuPercent(statsResponse).toString();
        print("Read $readS  - CPU : $cpuPercentS");
      } catch (e) {
        //Nothing to show if decode failed
      }
    });
    HttpRequest req = new HttpRequest();
    req.open('GET', 'http://192.168.1.19:2375/containers/1e9410a73aed/stats',
        async: true);
    req.onProgress.listen((ProgressEvent e) {
      stream.add(req.responseText);
    });
    req.send();
  }
}