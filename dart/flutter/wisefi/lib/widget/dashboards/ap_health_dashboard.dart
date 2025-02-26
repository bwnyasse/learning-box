import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../helpers/helpers.dart';
import '../components/summary_card.dart';
import '../components/ap_card.dart';

class APHealthDashboard extends StatefulWidget {
  final List<FortiAPData> fortiAPData;

  const APHealthDashboard({
    Key? key,
    required this.fortiAPData,
  }) : super(key: key);

  @override
  State<APHealthDashboard> createState() => _APHealthDashboardState();
}

class _APHealthDashboardState extends State<APHealthDashboard> {
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
                  // Summary Cards
                  _buildSummaryCards(context),
                  const SizedBox(height: 24),

                  // Network Health Section
                  _buildNetworkHealthSection(context),
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
          'AP Health & Performance',
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

  Widget _buildSummaryCards(BuildContext context) {
    // Calculate summary statistics from FortiAPData
    int totalAPs = widget.fortiAPData.length;
    
    int onlineAPs = widget.fortiAPData
        .where((ap) => ap.status == 'online')
        .length;
    
    int offlineAPs = widget.fortiAPData
        .where((ap) => ap.status == 'offline')
        .length;
    
    int warningAPs = widget.fortiAPData
        .where((ap) => ap.status == 'warning')
        .length;
    
    int totalClients = 0;
    int totalRogueAPs = 0;
    
    for (var ap in widget.fortiAPData) {
      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          totalClients += radio.clientCount ?? 0;
          totalRogueAPs += radio.detectedRogueAps ?? 0;
        }
      }
    }

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SummaryCard(
          title: 'Total APs',
          value: totalAPs.toString(),
          icon: Icons.router,
          color: Colors.blue,
          trend: '+0%',
        ),
        SummaryCard(
          title: 'Connected Clients',
          value: totalClients.toString(),
          icon: Icons.devices,
          color: Colors.green,
          trend: '+5%',
        ),
        SummaryCard(
          title: 'Rogue APs',
          value: totalRogueAPs.toString(),
          icon: Icons.security,
          color: Colors.orange,
          trend: '+2',
        ),
        SummaryCard(
          title: 'Critical Alerts',
          value: (offlineAPs + warningAPs).toString(),
          icon: Icons.warning_amber,
          color: Colors.red,
          trend: offlineAPs > 0 ? '+$offlineAPs' : '0',
        ),
      ],
    );
  }

  Widget _buildNetworkHealthSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            'Network Health',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Performance Metrics',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: 'Last 24 Hours',
                      items: const [
                        DropdownMenuItem(
                          value: 'Last 24 Hours',
                          child: Text('Last 24 Hours'),
                        ),
                        DropdownMenuItem(
                          value: 'Last Week',
                          child: Text('Last Week'),
                        ),
                        DropdownMenuItem(
                          value: 'Last Month',
                          child: Text('Last Month'),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ],
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
                      labelFormat: '{value}%',
                      minimum: 0,
                      maximum: 100,
                    ),
                    series: <CartesianSeries<ChartData, DateTime>>[
                      LineSeries<ChartData, DateTime>(
                        name: '2.4GHz Utilization',
                        dataSource: _getUtilizationData('2.4GHz'),
                        xValueMapper: (ChartData data, _) => data.time,
                        yValueMapper: (ChartData data, _) => data.value,
                        color: Colors.orange,
                        markerSettings: const MarkerSettings(isVisible: true),
                      ),
                      LineSeries<ChartData, DateTime>(
                        name: '5GHz Utilization',
                        dataSource: _getUtilizationData('5GHz'),
                        xValueMapper: (ChartData data, _) => data.time,
                        yValueMapper: (ChartData data, _) => data.value,
                        color: Colors.blue,
                        markerSettings: const MarkerSettings(isVisible: true),
                      ),
                      LineSeries<ChartData, DateTime>(
                        name: 'Signal Strength',
                        dataSource: _getSignalStrengthData(),
                        xValueMapper: (ChartData data, _) => data.time,
                        yValueMapper: (ChartData data, _) => data.value,
                        color: Colors.green,
                        markerSettings: const MarkerSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // AP Cards Grid
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: widget.fortiAPData.take(6).map((ap) => APCard(apData: ap)).toList(),
        ),
        
        // View all APs button
        if (widget.fortiAPData.length > 6)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('View All APs'),
              ),
            ),
          ),
      ],
    );
  }

  // Data generation methods for charts
  List<ChartData> _getUtilizationData(String band) {
    final now = DateTime.now();
    final data = <ChartData>[];
    
    // Try to extract real data from FortiAPData if available
    if (widget.fortiAPData.isNotEmpty) {
      Map<DateTime, double> utilByTime = {};
      int dataPoints = 0;
      
      for (var ap in widget.fortiAPData) {
        if (ap.radios != null) {
          for (var radio in ap.radios!) {
            if ((band == '2.4GHz' && radio.radioType == '2.4GHz') ||
                (band == '5GHz' && radio.radioType == '5GHz')) {
              
              // Use timestamp if available, or create synthetic timestamps
              DateTime timestamp = ap.timestamp ?? 
                  now.subtract(Duration(hours: dataPoints % 24));
                  
              if (radio.channelUtilizationPercent != null) {
                if (utilByTime.containsKey(timestamp)) {
                  // Average with existing data point
                  utilByTime[timestamp] = (utilByTime[timestamp]! + radio.channelUtilizationPercent!) / 2;
                } else {
                  utilByTime[timestamp] = radio.channelUtilizationPercent!.toDouble();
                }
                dataPoints++;
              }
            }
          }
        }
      }
      
      // Convert map to sorted list
      if (utilByTime.isNotEmpty) {
        final sortedTimes = utilByTime.keys.toList()..sort();
        for (var time in sortedTimes) {
          data.add(ChartData(time, utilByTime[time]!));
        }
        return data;
      }
    }
    
    // Fallback to generate sample data if no real data available
    return List.generate(
      24,
      (index) {
        final value = band == '2.4GHz'
            ? 30 + (index % 2 == 0 ? 5 : 0) + (index * 1.5)
            : 20 + (index % 3 == 0 ? 10 : 0) + (index * 0.8);
        return ChartData(
          now.subtract(Duration(hours: 24 - index)),
          value > 80 ? 80 : value,
        );
      },
    );
  }

  List<ChartData> _getSignalStrengthData() {
    final now = DateTime.now();
    
    // Generate sample signal strength data (would use real data in production)
    return List.generate(
      24,
      (index) {
        // Signal strength as percentage (higher is better)
        final value = 75 + (index % 4 == 0 ? -5 : 5) + (index * 0.2);
        return ChartData(
          now.subtract(Duration(hours: 24 - index)),
          value > 95 ? 95 : (value < 65 ? 65 : value),
        );
      },
    );
  }
}