import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../helpers/helpers.dart';

class SecurityMonitoringDashboard extends StatefulWidget {
  final List<FortiAPData> fortiAPData;
  final List<FortiManagerData> fortiManagerData;

  const SecurityMonitoringDashboard({
    Key? key,
    required this.fortiAPData,
    required this.fortiManagerData,
  }) : super(key: key);

  @override
  State<SecurityMonitoringDashboard> createState() =>
      _SecurityMonitoringDashboardState();
}

class _SecurityMonitoringDashboardState
    extends State<SecurityMonitoringDashboard> {
  String _timeRange = 'Last 24 Hours';
  String _selectedLocation = 'All Locations';

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
                  // Security Overview Cards
                  _buildSecurityOverviewCards(context),
                  const SizedBox(height: 24),

                  // Rogue AP Detection Section
                  _buildRogueAPSection(context),
                  const SizedBox(height: 24),

                  // Security Events Timeline
                  _buildSecurityEventsTimeline(context),
                  const SizedBox(height: 24),

                  // Correlated Security Events
                  _buildCorrelatedSecurityEvents(context),
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
          'Security Monitoring',
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
    // Extract unique locations from FortiAP data
    final locations = ['All Locations'];

    widget.fortiAPData
        .where((ap) => ap.dv_location != null)
        .map((ap) => ap.dv_location!)
        .toSet()
        .forEach((location) => locations.add(location));

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

          // Location filter
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: _selectedLocation,
              items: locations
                  .map((location) => DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLocation = value;
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

  Widget _buildSecurityOverviewCards(BuildContext context) {
    // Count detected rogue APs and interfering APs
    int totalRogueAPs = 0;
    int totalInterferingAPs = 0;
    int totalCriticalAlerts = 0;
    int totalSecurityEvents = 0;

    // Filter APs by selected location
    final filteredAPs = _selectedLocation == 'All Locations'
        ? widget.fortiAPData
        : widget.fortiAPData
            .where((ap) => ap.dv_location == _selectedLocation)
            .toList();

    // Count rogue APs and interfering APs from FortiAP data
    for (var ap in filteredAPs) {
      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          totalRogueAPs += radio.detectedRogueAps ?? 0;
          totalInterferingAPs += radio.interferingAps ?? 0;

          // Count critical health issues
          if (radio.health != null &&
              radio.health!.containsKey('overall') &&
              radio.health!['overall'] is Map &&
              radio.health!['overall']['severity'] == 'critical') {
            totalCriticalAlerts++;
          }
        }
      }
    }

    // Filter FortiManager data by selected location and security-related events
    final filteredManagerData = widget.fortiManagerData.where((data) {
      // Check if we need to filter by location
      if (_selectedLocation != 'All Locations') {
        // Match by device name containing the location code
        if (data.dev != null &&
            data.dev!.containsKey('name') &&
            !data.dev!['name'].toString().contains(_selectedLocation)) {
          return false;
        }
      }

      // Count only security-related events
      final level = data.level ?? '';
      final msg = data.msg ?? '';

      return level == 'warning' ||
          level == 'critical' ||
          msg.toLowerCase().contains('security') ||
          msg.toLowerCase().contains('attack') ||
          msg.toLowerCase().contains('breach') ||
          msg.toLowerCase().contains('unauthorized');
    }).toList();

    totalSecurityEvents = filteredManagerData.length;

    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSecurityCard(
          context,
          'Rogue APs',
          totalRogueAPs.toString(),
          Icons.security,
          Colors.red,
          totalRogueAPs > 0 ? 'High Risk' : 'Low Risk',
        ),
        _buildSecurityCard(
          context,
          'Interfering APs',
          totalInterferingAPs.toString(),
          Icons.wifi_tethering_error,
          Colors.orange,
          totalInterferingAPs > 5 ? 'Medium Risk' : 'Low Risk',
        ),
        _buildSecurityCard(
          context,
          'Critical Alerts',
          totalCriticalAlerts.toString(),
          Icons.warning_amber,
          Colors.amber,
          totalCriticalAlerts > 0 ? 'Needs Attention' : 'All Clear',
        ),
        _buildSecurityCard(
          context,
          'Security Events',
          totalSecurityEvents.toString(),
          Icons.event_note,
          Colors.blue,
          totalSecurityEvents > 5 ? 'Review Needed' : 'Normal Activity',
        ),
      ],
    );
  }

  Widget _buildSecurityCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String status,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRogueAPSection(BuildContext context) {
    // Extract APs with rogue AP detections
    final apsWithRogueDetections = widget.fortiAPData.where((ap) {
      // Filter by location if needed
      if (_selectedLocation != 'All Locations' &&
          ap.dv_location != _selectedLocation) {
        return false;
      }

      // Check for rogue AP detections
      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          if ((radio.detectedRogueAps ?? 0) > 0) {
            return true;
          }
        }
      }
      return false;
    }).toList();

    // Extract count data for chart
    final rogueAPByLocation = <String, int>{};

    for (var ap in widget.fortiAPData) {
      if (ap.dv_location != null && ap.radios != null) {
        int locationRogueCount = 0;

        for (var radio in ap.radios!) {
          locationRogueCount += radio.detectedRogueAps ?? 0;
        }

        if (locationRogueCount > 0) {
          if (rogueAPByLocation.containsKey(ap.dv_location)) {
            rogueAPByLocation[ap.dv_location!] = locationRogueCount;
          } else {
            rogueAPByLocation[ap.dv_location!] = locationRogueCount;
          }
        }
      }
    }

    // Convert to chart data
    final chartData = rogueAPByLocation.entries
        .map((entry) => ChartData(DateTime.now(), entry.value.toDouble(),
            category: entry.key))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Rogue AP Detections',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                OutlinedButton.icon(
                  icon: const Icon(Icons.security),
                  label: const Text('View Threats'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chart of rogue APs by location
            if (chartData.isNotEmpty) ...[
              SizedBox(
                height: 250,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Rogue AP Count'),
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.value,
                      name: 'Rogue APs',
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // List of APs with rogue detections
            Text(
              'Access Points with Rogue AP Detections',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),

            if (apsWithRogueDetections.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No rogue AP detections found'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apsWithRogueDetections.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final ap = apsWithRogueDetections[index];

                  // Calculate total rogue APs detected by this AP
                  int rogueAPCount = 0;
                  if (ap.radios != null) {
                    for (var radio in ap.radios!) {
                      rogueAPCount += radio.detectedRogueAps ?? 0;
                    }
                  }

                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_find,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(ap.name ?? 'Unknown AP'),
                    subtitle: Text(
                        '${ap.dv_location ?? "Unknown Location"} • ${ap.status ?? "Unknown Status"}'),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$rogueAPCount Rogue APs',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Show detailed view
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityEventsTimeline(BuildContext context) {
    // Filter security-related events from FortiManager data
    final securityEvents = widget.fortiManagerData.where((data) {
      // Check if we need to filter by location
      if (_selectedLocation != 'All Locations') {
        // Match by device name containing the location code
        if (data.dev != null &&
            data.dev!.containsKey('name') &&
            !data.dev!['name'].toString().contains(_selectedLocation)) {
          return false;
        }
      }

      // Include security-related events
      final level = data.level ?? '';
      final msg = data.msg ?? '';

      return level == 'warning' ||
          level == 'critical' ||
          msg.toLowerCase().contains('security') ||
          msg.toLowerCase().contains('attack') ||
          msg.toLowerCase().contains('breach') ||
          msg.toLowerCase().contains('unauthorized');
    }).toList();

    // Sort by date (newest first)
    securityEvents.sort((a, b) {
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
            Text(
              'Security Events Timeline',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (securityEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No security events found'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    securityEvents.length > 5 ? 5 : securityEvents.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final event = securityEvents[index];
                  final level = event.level ?? 'information';

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
                    title: Text(event.msg ?? 'Unknown Event'),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(width: 4),
                        Text(event.getUserName()),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(width: 4),
                        Text(event.date != null
                            ? DateFormat('MMM d, h:mm a').format(event.date!)
                            : 'Unknown time'),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).disabledColor,
                    ),
                    onTap: () {
                      // Show detailed view
                    },
                  );
                },
              ),
            if (securityEvents.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('View All ${securityEvents.length} Events'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrelatedSecurityEvents(BuildContext context) {
    // This section shows correlated events by combining data from both sources
    // For example, showing configuration changes that might have triggered security issues

    // List of correlated events (simplified example)
    final correlatedEvents = <Map<String, dynamic>>[];

    // Check for APs with warning/critical health around the time of config changes
    for (var ap in widget.fortiAPData) {
      // Skip if filtered by location
      if (_selectedLocation != 'All Locations' &&
          ap.dv_location != _selectedLocation) {
        continue;
      }

      // Check if this AP has health issues
      bool hasHealthIssues = false;
      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          if (radio.health != null &&
              radio.health!.containsKey('overall') &&
              radio.health!['overall'] is Map &&
              (radio.health!['overall']['severity'] == 'warning' ||
                  radio.health!['overall']['severity'] == 'critical')) {
            hasHealthIssues = true;
            break;
          }
        }
      }

      if (hasHealthIssues && ap.timestamp != null) {
        // Look for configuration changes around this time
        for (var event in widget.fortiManagerData) {
          if (event.action == 'config_change' &&
              event.date != null &&
              event.dev != null &&
              event.dev!.containsKey('name')) {
            // Check if the event is related to this AP or its controller
            final isRelated = event.dev!['name']
                    .toString()
                    .contains(ap.dv_fortigate_name ?? '') ||
                event.dev!['name'].toString().contains(ap.name ?? '');

            // Check if the event occurred within 1 hour of the health issue
            final timeDiff =
                event.date!.difference(ap.timestamp!).inHours.abs();

            if (isRelated && timeDiff <= 1) {
              correlatedEvents.add({
                'ap': ap,
                'event': event,
                'type': 'config_health_correlation',
                'description':
                    'Configuration change may have affected AP health'
              });
              break;
            }
          }
        }
      }
    }

    // Check for rogue AP detections followed by security events
    for (var ap in widget.fortiAPData) {
      // Skip if filtered by location
      if (_selectedLocation != 'All Locations' &&
          ap.dv_location != _selectedLocation) {
        continue;
      }

      // Check if this AP has detected rogue APs
      bool hasRogueDetections = false;
      if (ap.radios != null) {
        for (var radio in ap.radios!) {
          if ((radio.detectedRogueAps ?? 0) > 0) {
            hasRogueDetections = true;
            break;
          }
        }
      }

      if (hasRogueDetections && ap.timestamp != null) {
        // Look for security events after this detection
        for (var event in widget.fortiManagerData) {
          if ((event.level == 'warning' || event.level == 'critical') &&
              event.date != null &&
              event.date!.isAfter(ap.timestamp!) &&
              event.date!.difference(ap.timestamp!).inHours <= 4) {
            correlatedEvents.add({
              'ap': ap,
              'event': event,
              'type': 'rogue_security_correlation',
              'description': 'Security event occurred after rogue AP detection'
            });
            break;
          }
        }
      }
    }

    // If no correlated events found, add some examples for demonstration
    if (correlatedEvents.isEmpty &&
        widget.fortiAPData.isNotEmpty &&
        widget.fortiManagerData.isNotEmpty) {
      final sampleAP = widget.fortiAPData.first;
      final sampleEvent = widget.fortiManagerData.first;

      correlatedEvents.add({
        'ap': sampleAP,
        'event': sampleEvent,
        'type': 'config_health_correlation',
        'description':
            'Configuration change may have affected AP health (Sample)'
      });

      if (widget.fortiManagerData.length > 1) {
        correlatedEvents.add({
          'ap': sampleAP,
          'event': widget.fortiManagerData[1],
          'type': 'rogue_security_correlation',
          'description':
              'Security event occurred after rogue AP detection (Sample)'
        });
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Correlated Security Events',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Events that may be related based on timing and context',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (correlatedEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No correlated events found'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: correlatedEvents.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final correlation = correlatedEvents[index];
                  final ap = correlation['ap'] as FortiAPData;
                  final event = correlation['event'] as FortiManagerData;
                  final description = correlation['description'] as String;
                  final type = correlation['type'] as String;

                  // Choose icon and color based on correlation type
                  IconData icon;
                  Color color;

                  switch (type) {
                    case 'config_health_correlation':
                      icon = Icons.engineering;
                      color = Colors.orange;
                      break;
                    case 'rogue_security_correlation':
                      icon = Icons.security_update_warning;
                      color = Colors.red;
                      break;
                    default:
                      icon = Icons.link;
                      color = Colors.blue;
                  }

                  return ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                      ),
                    ),
                    title: Text(description),
                    subtitle: Text(
                        '${ap.name ?? "Unknown AP"} • ${event.date != null ? DateFormat('MMM d, h:mm a').format(event.date!) : "Unknown time"}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Access Point',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                          'Name', ap.name ?? 'Unknown'),
                                      _buildDetailRow('Location',
                                          ap.dv_location ?? 'Unknown'),
                                      _buildDetailRow(
                                          'Status', ap.status ?? 'Unknown'),
                                      if (ap.radios != null &&
                                          ap.radios!.isNotEmpty)
                                        _buildDetailRow(
                                            'Health',
                                            ap.radios!.first.health != null &&
                                                    ap.radios!.first.health!
                                                        .containsKey(
                                                            'overall') &&
                                                    ap.radios!.first
                                                            .health!['overall']
                                                        is Map
                                                ? ap.radios!.first
                                                        .health!['overall']
                                                    ['severity']
                                                : 'Unknown'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Related Event',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                          'Type', event.action ?? 'Unknown'),
                                      _buildDetailRow(
                                          'Level', event.level ?? 'Unknown'),
                                      _buildDetailRow(
                                          'User', event.getUserName()),
                                      _buildDetailRow(
                                          'Message', event.msg ?? 'No message'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.security),
                                  label: const Text('Investigate'),
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text('Mark Resolved'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
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
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // Helper methods for icon and color selection
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
}
