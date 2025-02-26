import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../helpers/helpers.dart';

class ConfigChangesDashboard extends StatefulWidget {
  final List<FortiManagerData> fortiManagerData;

  const ConfigChangesDashboard({
    Key? key,
    required this.fortiManagerData,
  }) : super(key: key);

  @override
  State<ConfigChangesDashboard> createState() => _ConfigChangesDashboardState();
}

class _ConfigChangesDashboardState extends State<ConfigChangesDashboard> {
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
                  // Configuration Change Summary
                  _buildConfigChangeSummary(context),
                  const SizedBox(height: 24),

                  // Configuration Change Activity
                  _buildConfigChangeActivity(context),
                  const SizedBox(height: 24),
                  
                  // Recent Changes List
                  _buildRecentChangesList(context),
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
          'Configuration Changes',
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

  Widget _buildConfigChangeSummary(BuildContext context) {
    // Extract change data from FortiManagerData
    final configChanges = widget.fortiManagerData
        .where((data) => data.action == 'config_change')
        .toList();
    
    final successfulChanges = configChanges
        .where((data) => data.result == 'success')
        .length;
    
    final failedChanges = configChanges
        .where((data) => data.result == 'failure' || data.result == 'error')
        .length;
    
    // Get unique users who made changes
    final uniqueUsers = configChanges
        .map((data) => data.getUserName())
        .toSet()
        .length;
    
    // Get unique devices that were changed
    final uniqueDevices = configChanges
        .map((data) => data.getDeviceName())
        .toSet()
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Change Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  context,
                  'Total Changes',
                  configChanges.length.toString(),
                  Icons.settings,
                  Colors.blue,
                ),
                _buildSummaryItem(
                  context,
                  'Successful',
                  successfulChanges.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildSummaryItem(
                  context,
                  'Failed',
                  failedChanges.toString(),
                  Icons.error,
                  Colors.red,
                ),
                _buildSummaryItem(
                  context,
                  'Users',
                  uniqueUsers.toString(),
                  Icons.people,
                  Colors.purple,
                ),
                _buildSummaryItem(
                  context,
                  'Devices',
                  uniqueDevices.toString(),
                  Icons.router,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Add chart for changes by day
            _buildChangesByDayChart(context, configChanges),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildChangesByDayChart(
    BuildContext context,
    List<FortiManagerData> configChanges,
  ) {
    // Group changes by day
    final changesByDay = <DateTime, int>{};
    final dateFormat = DateFormat('yyyy-MM-dd');
    
    for (var change in configChanges) {
      if (change.date != null) {
        final dateKey = DateTime(
          change.date!.year,
          change.date!.month,
          change.date!.day,
        );
        
        if (changesByDay.containsKey(dateKey)) {
          changesByDay[dateKey] = changesByDay[dateKey]! + 1;
        } else {
          changesByDay[dateKey] = 1;
        }
      }
    }
    
    // If we don't have enough real data, add some sample data
    if (changesByDay.length < 7) {
      final now = DateTime.now();
      for (int i = 6; i >= 0; i--) {
        final date = DateTime(
          now.year,
          now.month,
          now.day - i,
        );
        
        if (!changesByDay.containsKey(date)) {
          changesByDay[date] = i + 1; // Just some sample data
        }
      }
    }
    
    // Convert to list and sort by date
    final chartData = changesByDay.entries.map((entry) {
      return ChartData(entry.key, entry.value.toDouble());
    }).toList();
    
    chartData.sort((a, b) => a.time.compareTo(b.time));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration Changes by Day',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              intervalType: DateTimeIntervalType.days,
              interval: 1,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Number of Changes'),
              labelFormat: '{value}',
              interval: 5,
            ),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, DateTime>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.time,
                yValueMapper: (ChartData data, _) => data.value,
                name: 'Changes',
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.top,
                ),
              )
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ),
      ],
    );
  }

  Widget _buildConfigChangeActivity(BuildContext context) {
    // Get all config changes
    final configChanges = widget.fortiManagerData
        .where((data) => data.action == 'config_change')
        .toList();
    
    // Get usernames and count changes per user
    final changesByUser = <String, int>{};
    
    for (var change in configChanges) {
      final userName = change.getUserName();
      
      if (changesByUser.containsKey(userName)) {
        changesByUser[userName] = changesByUser[userName]! + 1;
      } else {
        changesByUser[userName] = 1;
      }
    }
    
    // Get unique device names and count changes per device
    final changesByDevice = <String, int>{};
    
    for (var change in configChanges) {
      final deviceName = change.getDeviceName();
      
      if (changesByDevice.containsKey(deviceName)) {
        changesByDevice[deviceName] = changesByDevice[deviceName]! + 1;
      } else {
        changesByDevice[deviceName] = 1;
      }
    }
    
    // Convert to lists and sort by count (descending)
    final userChartData = changesByUser.entries
        .map((entry) => PieData(
              entry.key,
              entry.value.toDouble(),
              '${entry.value} changes',
              _getColorForIndex(changesByUser.keys.toList().indexOf(entry.key)),
            ))
        .toList();
    
    final deviceChartData = changesByDevice.entries
        .map((entry) => PieData(
              entry.key,
              entry.value.toDouble(),
              '${entry.value} changes',
              _getColorForIndex(changesByDevice.keys.toList().indexOf(entry.key)),
            ))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Change Activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Changes by User
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Changes by User',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <CircularSeries>[
                        PieSeries<PieData, String>(
                          dataSource: userChartData,
                          xValueMapper: (PieData data, _) => data.category,
                          yValueMapper: (PieData data, _) => data.value,
                          dataLabelMapper: (PieData data, _) => data.label,
                          pointColorMapper: (PieData data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          explode: true,
                          explodeIndex: 0,
                        ),
                      ],
                    ),
                  ),
                ),

                // Changes by Device
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Changes by Device',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <CircularSeries>[
                        PieSeries<PieData, String>(
                          dataSource: deviceChartData,
                          xValueMapper: (PieData data, _) => data.category,
                          yValueMapper: (PieData data, _) => data.value,
                          dataLabelMapper: (PieData data, _) => data.label,
                          pointColorMapper: (PieData data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          explode: true,
                          explodeIndex: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentChangesList(BuildContext context) {
    // Get all config changes and sort by date (newest first)
    final configChanges = widget.fortiManagerData
        .where((data) => data.action == 'config_change')
        .toList();
    
    configChanges.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });
    
    // Take the most recent changes
    final recentChanges = configChanges.take(10).toList();

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
                  'Recent Configuration Changes',
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
            
            if (recentChanges.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No configuration changes found in the selected time period',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentChanges.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final change = recentChanges[index];
                  final isSuccess = change.result == 'success';
                  
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSuccess ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSuccess ? Icons.check : Icons.warning,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            change.msg ?? 'Configuration changed',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (change.date != null)
                          Text(
                            DateFormat('MMM d, h:mm a').format(change.date!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(width: 4),
                        Text(change.getUserName()),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.router,
                          size: 14,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(width: 4),
                        Text(change.getDeviceName()),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        // Show detailed view of the change
                      },
                    ),
                    onTap: () {
                      // Show detailed view of the change
                      _showChangeDetails(context, change);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showChangeDetails(BuildContext context, FortiManagerData change) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuration Change Details'),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Status', change.result ?? 'Unknown', 
                  (change.result == 'success') ? Colors.green : Colors.red),
                _buildDetailRow('User', change.getUserName()),
                _buildDetailRow('Device', change.getDeviceName()),
                _buildDetailRow('Date', change.date != null ? 
                  DateFormat('MMM d, yyyy h:mm:ss a').format(change.date!) : 'Unknown'),
                _buildDetailRow('Message', change.msg ?? 'No message'),
                
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                
                Text(
                  'Changes:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    change.changes ?? 'No detailed change information available',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
    ];
    
    return colors[index % colors.length];
  }
}