import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../helpers/helpers.dart';

class AdminActivityDashboard extends StatefulWidget {
  final List<FortiManagerData> fortiManagerData;

  const AdminActivityDashboard({
    Key? key,
    required this.fortiManagerData,
  }) : super(key: key);

  @override
  State<AdminActivityDashboard> createState() => _AdminActivityDashboardState();
}

class _AdminActivityDashboardState extends State<AdminActivityDashboard> {
  String _timeRange = 'Last 24 Hours';
  String _selectedUser = 'All Users';
  String _selectedLevel = 'All Levels';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(context),
          const SizedBox(height: 16),
          _buildFilterBar(context),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity Overview
                  _buildActivityOverview(context),
                  const SizedBox(height: 24),

                  // Activity Timeline
                  _buildActivityTimeline(context),
                  const SizedBox(height: 24),

                  // Admin Activity Log
                  _buildActivityLog(context),
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
          'Admin Activity',
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

  Widget _buildFilterBar(BuildContext context) {
    // Get unique users
    final users = ['All Users'];
    users.addAll(
      widget.fortiManagerData
          .where((data) => data.user != null && data.user!.containsKey('name'))
          .map((data) => data.user!['name'] as String)
          .toSet()
          .toList(),
    );

    // Get unique activity levels
    final levels = ['All Levels'];
    levels.addAll(
      widget.fortiManagerData
          .where((data) => data.level != null)
          .map((data) => data.level!)
          .toSet()
          .toList(),
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Text('Filter by:'),
          const SizedBox(width: 16),

          // User filter
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'User',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: _selectedUser,
              items: users
                  .map((user) => DropdownMenuItem(
                        value: user,
                        child: Text(user),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedUser = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Level filter
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Level',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: _selectedLevel,
              items: levels
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(_formatLevel(level)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLevel = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Apply button
          ElevatedButton(
            onPressed: () {
              // Filters are applied immediately with setState
              // This button is for visual consistency
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityOverview(BuildContext context) {
    // Filter data based on selected filters
    final filteredData = _getFilteredData();

    // Count activities by action type
    final actionCounts = <String, int>{};
    for (var activity in filteredData) {
      final action = activity.action ?? 'unknown';
      if (actionCounts.containsKey(action)) {
        actionCounts[action] = actionCounts[action]! + 1;
      } else {
        actionCounts[action] = 1;
      }
    }

    // Count activities by level
    final levelCounts = <String, int>{};
    for (var activity in filteredData) {
      final level = activity.level ?? 'unknown';
      if (levelCounts.containsKey(level)) {
        levelCounts[level] = levelCounts[level]! + 1;
      } else {
        levelCounts[level] = 1;
      }
    }

    // Count activities by result
    final resultCounts = <String, int>{};
    for (var activity in filteredData) {
      final result = activity.result ?? 'unknown';
      if (resultCounts.containsKey(result)) {
        resultCounts[result] = resultCounts[result]! + 1;
      } else {
        resultCounts[result] = 1;
      }
    }

    // Prepare chart data
    final actionChartData = actionCounts.entries.map((entry) {
      return PieData(
        _formatAction(entry.key),
        entry.value.toDouble(),
        '${entry.value}',
        _getColorForAction(entry.key),
      );
    }).toList();

    final levelChartData = levelCounts.entries.map((entry) {
      return PieData(
        _formatLevel(entry.key),
        entry.value.toDouble(),
        '${entry.value}',
        _getColorForLevel(entry.key),
      );
    }).toList();

    final resultChartData = resultCounts.entries.map((entry) {
      return PieData(
        _formatResult(entry.key),
        entry.value.toDouble(),
        '${entry.value}',
        _getColorForResult(entry.key),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),

            // Total activity count
            Center(
              child: Column(
                children: [
                  Text(
                    'Total Admin Activities',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filteredData.length.toString(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Activity distribution charts
            Row(
              children: [
                // Actions pie chart
                Expanded(
                  child: SizedBox(
                    height: 230,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Activities by Action',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<PieData, String>(
                          dataSource: actionChartData,
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

                // Levels pie chart
                Expanded(
                  child: SizedBox(
                    height: 230,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Activities by Level',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<PieData, String>(
                          dataSource: levelChartData,
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

                // Results pie chart
                Expanded(
                  child: SizedBox(
                    height: 230,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Activities by Result',
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<PieData, String>(
                          dataSource: resultChartData,
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
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTimeline(BuildContext context) {
    final filteredData = _getFilteredData();

    // Count activities by hour
    final now = DateTime.now();
    final activityByHour = <DateTime, int>{};

    // Initialize with zeroes for all hours in the time range
    int hoursRange = 24;
    if (_timeRange == 'Last Week') {
      hoursRange = 24 * 7;
    } else if (_timeRange == 'Last Month') {
      hoursRange = 24 * 30;
    }

    for (int i = 0; i < hoursRange; i++) {
      final hour = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour - i,
      );
      activityByHour[hour] = 0;
    }

    // Count actual activities
    for (var activity in filteredData) {
      if (activity.date != null) {
        final activityHour = DateTime(
          activity.date!.year,
          activity.date!.month,
          activity.date!.day,
          activity.date!.hour,
        );

        if (activityByHour.containsKey(activityHour)) {
          activityByHour[activityHour] = activityByHour[activityHour]! + 1;
        }
      }
    }

    // Convert to chart data and sort by time
    final chartData = activityByHour.entries.map((entry) {
      return ChartData(entry.key, entry.value.toDouble());
    }).toList();

    chartData.sort((a, b) => a.time.compareTo(b.time));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Timeline',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  dateFormat: _timeRange == 'Last 24 Hours'
                      ? DateFormat.Hm()
                      : DateFormat.MMMd().add_Hm(),
                  intervalType: _timeRange == 'Last 24 Hours'
                      ? DateTimeIntervalType.hours
                      : DateTimeIntervalType.days,
                  interval: _timeRange == 'Last 24 Hours' ? 4 : 1,
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Activity Count'),
                  minimum: 0,
                ),
                series: <CartesianSeries>[
                  SplineAreaSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: 'Activities',
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    borderColor: Theme.of(context).colorScheme.primary,
                    borderWidth: 2,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),

            const SizedBox(height: 16),

            // Activity by user over time
            _buildActivityByUserTimeline(context, filteredData),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityByUserTimeline(
      BuildContext context, List<FortiManagerData> filteredData) {
    // Get unique users
    final users = filteredData
        .where((data) => data.user != null && data.user!.containsKey('name'))
        .map((data) => data.user!['name'] as String)
        .toSet()
        .toList();

    // Limit to top 5 users for clarity
    users.sort((a, b) {
      final countA = filteredData
          .where((data) =>
              data.user != null &&
              data.user!.containsKey('name') &&
              data.user!['name'] == a)
          .length;

      final countB = filteredData
          .where((data) =>
              data.user != null &&
              data.user!.containsKey('name') &&
              data.user!['name'] == b)
          .length;

      return countB.compareTo(countA); // Descending order
    });

    final topUsers = users.take(5).toList();

    // Group activities by day and user
    final now = DateTime.now();
    final activityByDayAndUser = <String, Map<DateTime, int>>{};

    // Initialize data structure
    for (var user in topUsers) {
      activityByDayAndUser[user] = {};

      // Initialize with zero counts
      int daysRange = 1;
      if (_timeRange == 'Last Week') {
        daysRange = 7;
      } else if (_timeRange == 'Last Month') {
        daysRange = 30;
      }

      for (int i = 0; i < daysRange; i++) {
        final day = DateTime(
          now.year,
          now.month,
          now.day - i,
        );
        activityByDayAndUser[user]![day] = 0;
      }
    }

    // Count activities
    for (var activity in filteredData) {
      if (activity.date != null &&
          activity.user != null &&
          activity.user!.containsKey('name')) {
        final userName = activity.user!['name'] as String;
        if (topUsers.contains(userName)) {
          final activityDay = DateTime(
            activity.date!.year,
            activity.date!.month,
            activity.date!.day,
          );

          if (activityByDayAndUser[userName]!.containsKey(activityDay)) {
            activityByDayAndUser[userName]![activityDay] =
                activityByDayAndUser[userName]![activityDay]! + 1;
          } else {
            activityByDayAndUser[userName]![activityDay] = 1;
          }
        }
      }
    }

    // Convert to chart series
    final List<ChartSeries> seriesList = <ChartSeries>[];

    for (var i = 0; i < topUsers.length; i++) {
      final user = topUsers[i];
      final userData = activityByDayAndUser[user]!
          .entries
          .map((entry) => ChartData(entry.key, entry.value.toDouble()))
          .toList();

      userData.sort((a, b) => a.time.compareTo(b.time));

      seriesList.add(
        LineSeries<ChartData, DateTime>(
          dataSource: userData,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          name: user,
          color: _getUserColor(i),
          markerSettings: MarkerSettings(
            isVisible: true,
            color: _getUserColor(i),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity by User',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              intervalType: DateTimeIntervalType.days,
              interval: 1,
            ),
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: 'Activity Count'),
              minimum: 0,
            ),
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
            ),
            series: seriesList.cast<CartesianSeries<dynamic, dynamic>>(),
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLog(BuildContext context) {
    final filteredData = _getFilteredData();

    // Sort by date (newest first)
    filteredData.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });

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
                  'Activity Log',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Export Log'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredData.isEmpty)
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
                        'No admin activities found with the selected filters',
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
                itemCount: filteredData.length > 10 ? 10 : filteredData.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activity = filteredData[index];
                  final level = activity.level ?? 'information';

                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getColorForLevel(level).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForLevel(level),
                        color: _getColorForLevel(level),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity.msg ?? _getDefaultMessage(activity),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (activity.date != null)
                          Text(
                            DateFormat('MMM d, h:mm a').format(activity.date!),
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
                        Text(activity.getUserName()),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _getColorForAction(activity.action ?? 'unknown')
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _formatAction(activity.action ?? 'unknown'),
                            style: TextStyle(
                              fontSize: 10,
                              color: _getColorForAction(
                                  activity.action ?? 'unknown'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: activity.result == 'success'
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : (activity.result == 'failure' ||
                                activity.result == 'error'
                            ? const Icon(Icons.error, color: Colors.red)
                            : null),
                    onTap: () {
                      // Show detailed view of the activity
                      _showActivityDetails(context, activity);
                    },
                  );
                },
              ),
            if (filteredData.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {
                      // Show full activity log
                    },
                    child: Text('View All ${filteredData.length} Activities'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showActivityDetails(BuildContext context, FortiManagerData activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Activity Details'),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                    'Action', _formatAction(activity.action ?? 'Unknown')),
                _buildDetailRow('User', activity.getUserName()),
                _buildDetailRow(
                    'Date',
                    activity.date != null
                        ? DateFormat('MMM d, yyyy h:mm:ss a')
                            .format(activity.date!)
                        : 'Unknown'),
                _buildDetailRow(
                    'Level',
                    _formatLevel(activity.level ?? 'unknown'),
                    _getColorForLevel(activity.level ?? 'unknown')),
                _buildDetailRow(
                    'Result',
                    _formatResult(activity.result ?? 'Unknown'),
                    _getColorForResult(activity.result ?? 'unknown')),
                _buildDetailRow('Message', activity.msg ?? 'No message'),
                if (activity.dev != null)
                  _buildDetailRow('Device', activity.getDeviceName()),
                if (activity.changes != null) ...[
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
                      activity.changes ?? '',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
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

  // Helper methods for data filtering and formatting
  List<FortiManagerData> _getFilteredData() {
    return widget.fortiManagerData.where((data) {
      // Filter by user
      if (_selectedUser != 'All Users' &&
          (data.user == null ||
              !data.user!.containsKey('name') ||
              data.user!['name'] != _selectedUser)) {
        return false;
      }

      // Filter by level
      if (_selectedLevel != 'All Levels' && data.level != _selectedLevel) {
        return false;
      }

      // Filter by time range
      if (data.date != null) {
        final now = DateTime.now();
        if (_timeRange == 'Last 24 Hours' &&
            now.difference(data.date!).inHours > 24) {
          return false;
        } else if (_timeRange == 'Last Week' &&
            now.difference(data.date!).inDays > 7) {
          return false;
        } else if (_timeRange == 'Last Month' &&
            now.difference(data.date!).inDays > 30) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  String _formatAction(String action) {
    switch (action) {
      case 'login':
        return 'Login';
      case 'logout':
        return 'Logout';
      case 'config_change':
        return 'Config Change';
      case 'device_registration':
        return 'Device Registration';
      case 'backup':
        return 'Backup';
      case 'restore':
        return 'Restore';
      case 'update':
        return 'Update';
      case 'reboot':
        return 'Reboot';
      default:
        return action
            .split('_')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '')
            .join(' ');
    }
  }

  String _formatLevel(String level) {
    switch (level) {
      case 'information':
        return 'Information';
      case 'warning':
        return 'Warning';
      case 'critical':
        return 'Critical';
      case 'debug':
        return 'Debug';
      default:
        return level
            .split('_')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '')
            .join(' ');
    }
  }

  String _formatResult(String result) {
    switch (result) {
      case 'success':
        return 'Success';
      case 'failure':
        return 'Failure';
      case 'error':
        return 'Error';
      case 'in_progress':
        return 'In Progress';
      default:
        return result
            .split('_')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '')
            .join(' ');
    }
  }

  String _getDefaultMessage(FortiManagerData activity) {
    final action = activity.action ?? 'unknown';
    final user = activity.getUserName();
    final device = activity.getDeviceName();

    switch (action) {
      case 'login':
        return 'User $user logged in';
      case 'logout':
        return 'User $user logged out';
      case 'config_change':
        return 'Configuration changed on $device';
      case 'device_registration':
        return 'Device $device registered';
      case 'backup':
        return 'Backup performed by $user';
      case 'restore':
        return 'Restore performed by $user';
      case 'update':
        return 'Update applied to $device';
      case 'reboot':
        return 'Device $device rebooted';
      default:
        return 'Admin activity: $action';
    }
  }

  Color _getColorForAction(String action) {
    switch (action) {
      case 'login':
        return Colors.green;
      case 'logout':
        return Colors.blue;
      case 'config_change':
        return Colors.orange;
      case 'device_registration':
        return Colors.purple;
      case 'backup':
        return Colors.teal;
      case 'restore':
        return Colors.indigo;
      case 'update':
        return Colors.amber;
      case 'reboot':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Color _getColorForLevel(String level) {
    switch (level) {
      case 'information':
        return Colors.blue;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      case 'debug':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForLevel(String level) {
    switch (level) {
      case 'information':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'critical':
        return Icons.error;
      case 'debug':
        return Icons.bug_report;
      default:
        return Icons.info;
    }
  }

  Color _getColorForResult(String result) {
    switch (result) {
      case 'success':
        return Colors.green;
      case 'failure':
      case 'error':
        return Colors.red;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getUserColor(int index) {
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
