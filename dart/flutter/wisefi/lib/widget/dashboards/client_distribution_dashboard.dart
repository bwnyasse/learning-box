import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../models/models.dart';
import '../../helpers/helpers.dart';

class ClientDistributionDashboard extends StatefulWidget {
  final List<FortiAPData> fortiAPData;

  const ClientDistributionDashboard({
    Key? key,
    required this.fortiAPData,
  }) : super(key: key);

  @override
  State<ClientDistributionDashboard> createState() =>
      _ClientDistributionDashboardState();
}

class _ClientDistributionDashboardState
    extends State<ClientDistributionDashboard> {
  String _timeRange = 'Last 24 Hours';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(context),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client Distribution Charts
                  _buildClientDistributionCharts(context),
                  const SizedBox(height: 24),

                  // Client Trend Section
                  _buildClientTrendSection(context),
                  const SizedBox(height: 24),

                  // Top APs by Client Count
                  _buildTopAPsSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Client Distribution',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Row(
          children: [
            DropdownButton<String>(
              value: _timeRange,
              items: ['Last 24 Hours', 'Last Week', 'Last Month']
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _timeRange = value;
                  });
                }
              },
              underline: Container(),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
              tooltip: 'Refresh Data',
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClientDistributionCharts(BuildContext context) {
    // Calculate client distribution by frequency band
    int clients24GHz = 0;
    int clients5GHz = 0;

    // Calculate client distribution by device type (simulated)
    int mobileClients = 0;
    int laptopClients = 0;
    int iotClients = 0;
    int otherClients = 0;

    // Extract client data from FortiAPData
    for (var ap in widget.fortiAPData) {
      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          final clientCount = radio.clientCount ?? 0;

          if (radio.radioType == '2.4GHz') {
            clients24GHz += clientCount;
          } else if (radio.radioType == '5GHz') {
            clients5GHz += clientCount;
          }

          // For device types, we don't have real data in the schema,
          // so we'll simulate a distribution based on frequency
          if (radio.radioType == '2.4GHz') {
            // 2.4GHz tends to have more IoT devices
            iotClients += (clientCount * 0.4).round();
            mobileClients += (clientCount * 0.3).round();
            laptopClients += (clientCount * 0.2).round();
            otherClients += (clientCount * 0.1).round();
          } else if (radio.radioType == '5GHz') {
            // 5GHz tends to have more mobile/laptop devices
            mobileClients += (clientCount * 0.45).round();
            laptopClients += (clientCount * 0.4).round();
            iotClients += (clientCount * 0.1).round();
            otherClients += (clientCount * 0.05).round();
          }
        }
      }
    }

    // Adjust totals to ensure they match
    final totalByBand = clients24GHz + clients5GHz;
    final totalByType =
        mobileClients + laptopClients + iotClients + otherClients;

    if (totalByBand != totalByType) {
      // Adjust the largest category to make totals match
      final diff = totalByBand - totalByType;
      if (diff > 0) {
        if (mobileClients >= laptopClients &&
            mobileClients >= iotClients &&
            mobileClients >= otherClients) {
          mobileClients += diff;
        } else if (laptopClients >= mobileClients &&
            laptopClients >= iotClients &&
            laptopClients >= otherClients) {
          laptopClients += diff;
        } else if (iotClients >= mobileClients &&
            iotClients >= laptopClients &&
            iotClients >= otherClients) {
          iotClients += diff;
        } else {
          otherClients += diff;
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Distribution',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Donut chart showing client distribution by band (2.4GHz vs 5GHz)
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Clients by Band',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<PieData, String>(
                          dataSource: [
                            PieData('2.4 GHz', clients24GHz.toDouble(),
                                '$clients24GHz clients', Colors.orange),
                            PieData('5 GHz', clients5GHz.toDouble(),
                                '$clients5GHz clients', Colors.blue),
                          ],
                          xValueMapper: (PieData data, _) => data.category,
                          yValueMapper: (PieData data, _) => data.value,
                          dataLabelMapper: (PieData data, _) => data.label,
                          pointColorMapper: (PieData data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          innerRadius: '60%',
                        ),
                      ],
                    ),
                  ),
                ),

                // Donut chart showing client distribution by device type
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Clients by Device Type',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<PieData, String>(
                          dataSource: [
                            PieData('Mobile', mobileClients.toDouble(),
                                '$mobileClients clients', Colors.purple),
                            PieData('Laptop', laptopClients.toDouble(),
                                '$laptopClients clients', Colors.teal),
                            PieData('IoT', iotClients.toDouble(),
                                '$iotClients clients', Colors.amber),
                            PieData('Other', otherClients.toDouble(),
                                '$otherClients clients', Colors.grey),
                          ],
                          xValueMapper: (PieData data, _) => data.category,
                          yValueMapper: (PieData data, _) => data.value,
                          dataLabelMapper: (PieData data, _) => data.label,
                          pointColorMapper: (PieData data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          innerRadius: '60%',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Location Distribution (simulated)
            const SizedBox(height: 32),
            _buildLocationDistributionChart(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDistributionChart(BuildContext context) {
    // Extract client counts by location from FortiAP data
    final Map<String, int> locationClientCounts = <String, int>{};

    for (var ap in widget.fortiAPData) {
      if (ap.dv_location != null) {
        int clientCount = 0;

        // Sum clients across both radios
        if (ap.radios != null) {
          for (var radio in ap.radios!) {
            clientCount += radio.clientCount ?? 0;
          }
        }

        // Add to location totals
        if (locationClientCounts.containsKey(ap.dv_location)) {
          locationClientCounts[ap.dv_location!] = clientCount;
        } else {
          locationClientCounts[ap.dv_location!] = clientCount;
        }
      }
    }

    // Convert to list for chart
    final locationData = locationClientCounts.entries.map((entry) {
      return {
        'location': entry.key,
        'clients': entry.value,
      };
    }).toList();

    // Sort by client count (descending)
    locationData
        .sort((a, b) => (b['clients'] as int).compareTo(a['clients'] as int));

    // If no data found, provide some sample data
    if (locationData.isEmpty) {
      locationData.addAll([
        {'location': 'ESD-NB-SUS-00010', 'clients': 52},
        {'location': 'ESD-QC-TRR-03450', 'clients': 100},
        {'location': 'DV1-QC-MON-00010', 'clients': 18},
        {'location': 'CBS-NB-MON-00327', 'clients': 99},
        {'location': 'ESD-NB-YAR-00013', 'clients': 26},
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clients by Location',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: 'Client Count'),
              labelFormat: '{value}',
            ),
            series: <CartesianSeries>[
              ColumnSeries<Map<String, dynamic>, String>(
                dataSource: locationData,
                xValueMapper: (Map<String, dynamic> data, _) =>
                    data['location'] as String,
                yValueMapper: (Map<String, dynamic> data, _) =>
                    data['clients'] as int,
                name: 'Clients',
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.top,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClientTrendSection(BuildContext context) {
    final clientTrendData = _getClientTrendData();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Count Trends',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.Hm(),
                  intervalType: DateTimeIntervalType.hours,
                  interval: 4,
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Client Count'),
                  minimum: 0,
                ),
                series: <CartesianSeries<ChartData, DateTime>>[
                  // Total clients
                  AreaSeries<ChartData, DateTime>(
                    name: 'Total Clients',
                    dataSource: clientTrendData,
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.value,
                    color: Colors.blue.withOpacity(0.5),
                    borderColor: Colors.blue,
                    borderWidth: 2,
                  ),
                  // 2.4GHz clients
                  LineSeries<ChartData, DateTime>(
                    name: '2.4GHz Clients',
                    dataSource: clientTrendData
                        .where((data) => data.category == '2.4GHz')
                        .toList(),
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.value,
                    color: Colors.orange,
                  ),
                  // 5GHz clients
                  LineSeries<ChartData, DateTime>(
                    name: '5GHz Clients',
                    dataSource: clientTrendData
                        .where((data) => data.category == '5GHz')
                        .toList(),
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.value,
                    color: Colors.blue,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),

            const SizedBox(height: 16),

            // Key metrics
            _buildClientMetricsSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildClientMetricsSummary(BuildContext context) {
    // Calculate metrics from data
    int totalClients = 0;
    int maxClientsPerAP = 0;
    String busyAP = "";

    for (var ap in widget.fortiAPData) {
      int apClients = 0;

      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          apClients += radio.clientCount ?? 0;
        }
      }

      totalClients += apClients;

      if (apClients > maxClientsPerAP) {
        maxClientsPerAP = apClients;
        busyAP = ap.name ?? "Unknown AP";
      }
    }

    // Calculate average clients per AP
    final avgClientsPerAP = widget.fortiAPData.isNotEmpty
        ? (totalClients / widget.fortiAPData.length).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Key Metrics',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Total Clients',
                  totalClients.toString(),
                  Icons.devices,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Avg Clients per AP',
                  avgClientsPerAP.toString(),
                  Icons.router,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  context,
                  'Busiest AP',
                  '$busyAP ($maxClientsPerAP)',
                  Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
      BuildContext context, String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTopAPsSection(BuildContext context) {
    // Sort APs by client count
    final List<FortiAPData> sortedAPs = List.from(widget.fortiAPData);
    sortedAPs.sort((a, b) {
      int aClients = 0;
      int bClients = 0;

      if (a.radios != null) {
        for (var radio in a.radios!) {
          aClients += radio.clientCount ?? 0;
        }
      }

      if (b.radios != null) {
        for (var radio in b.radios!) {
          bClients += radio.clientCount ?? 0;
        }
      }

      return bClients.compareTo(aClients); // Descending order
    });

    // Take top 5 APs
    final topAPs = sortedAPs.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top APs by Client Count',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.list),
                  label: const Text('View All'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (var ap in topAPs) _buildTopAPItem(context, ap),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAPItem(BuildContext context, FortiAPData ap) {
    // Calculate total clients for this AP
    int clients = 0;
    int clients24GHz = 0;
    int clients5GHz = 0;

    if (ap.radios != null) {
      for (var radio in ap.radios!) {
        final clientCount = radio.clientCount ?? 0;
        clients += clientCount;

        if (radio.radioType == '2.4GHz') {
          clients24GHz = clientCount;
        } else if (radio.radioType == '5GHz') {
          clients5GHz = clientCount;
        }
      }
    }

    // Calculate percentage of max capacity (assume 50 is max for now)
    final capacity = 50;
    final usagePercent = (clients / capacity * 100).clamp(0, 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.router,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                ap.name ?? 'Unknown AP',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Text(
                '$clients clients',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Usage bar
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Capacity Usage',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          '$usagePercent%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: usagePercent / 100,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      color: usagePercent < 70
                          ? Colors.green
                          : (usagePercent < 90 ? Colors.orange : Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Client distribution
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _buildBandIndicator(
                        context, '2.4GHz', clients24GHz, Colors.orange),
                    const SizedBox(width: 16),
                    _buildBandIndicator(
                        context, '5GHz', clients5GHz, Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBandIndicator(
      BuildContext context, String band, int clients, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          band,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              clients.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  // Data generation methods
  List<ChartData> _getClientTrendData() {
    final now = DateTime.now();
    final random = Random();

    // Generate historical client count data (total and by band)
    List<ChartData> result = [];

    // Base values that will increase/decrease over time
    double clients24Base = 100 + random.nextDouble() * 50;
    double clients5Base = 150 + random.nextDouble() * 100;

    // Generate data for a 24-hour period
    for (int i = 0; i < 24; i++) {
      final time = now.subtract(Duration(hours: 24 - i));

      // Add time-of-day variation
      double timeVariation;
      final hour = time.hour;

      if (hour >= 9 && hour <= 17) {
        // Business hours - higher usage
        timeVariation = 1.0 + ((hour - 9) / 8) * 0.5; // Peak at 2-3 PM
        if (hour >= 13) {
          timeVariation = 1.5 - ((hour - 13) / 8) * 0.5; // Decline after lunch
        }
      } else if (hour >= 18 && hour <= 22) {
        // Evening - moderate usage
        timeVariation = 0.7 - ((hour - 18) / 4) * 0.3;
      } else {
        // Night - low usage
        timeVariation = 0.4;
      }

      // Calculate client counts for this hour
      double randomVariation =
          0.9 + random.nextDouble() * 0.2; // ±10% random variation

      double clients24 = clients24Base * timeVariation * randomVariation;
      double clients5 = clients5Base * timeVariation * randomVariation;

      // Add data points for each band
      result.add(ChartData(time, clients24, category: '2.4GHz'));
      result.add(ChartData(time, clients5, category: '5GHz'));

      // Add total
      result.add(ChartData(time, clients24 + clients5));

      // Slight adjustments to base values for next hour
      clients24Base += random.nextDouble() * 10 - 5; // ±5 variation
      clients5Base += random.nextDouble() * 15 - 7; // ±7 variation

      // Keep values within reasonable limits
      clients24Base = clients24Base.clamp(80.0, 200.0);
      clients5Base = clients5Base.clamp(100.0, 300.0);
    }

    return result;
  }
}
