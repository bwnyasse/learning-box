import 'package:flutter/material.dart';
import '../../models/models.dart';

class APCard extends StatelessWidget {
  final FortiAPData apData;

  const APCard({
    Key? key,
    required this.apData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data from the apData object
    final name = apData.name ?? 'Unknown AP';
    final status = apData.status ?? 'unknown';
    
    // Get radio data
    RadioData? radio24GHz;
    RadioData? radio5GHz;
    
    if (apData.radios != null) {
      for (var radio in apData.radios!) {
        if (radio.radioType == '2.4GHz') {
          radio24GHz = radio;
        } else if (radio.radioType == '5GHz') {
          radio5GHz = radio;
        }
      }
    }

    // Calculate total client count
    int clientCount = 0;
    if (radio24GHz != null) clientCount += radio24GHz.clientCount ?? 0;
    if (radio5GHz != null) clientCount += radio5GHz.clientCount ?? 0;
    
    // Get channel information
    final channel24 = radio24GHz?.operChan != null ? 'Ch ${radio24GHz?.operChan}' : 'N/A';
    final channel5 = radio5GHz?.operChan != null ? 'Ch ${radio5GHz?.operChan}' : 'N/A';
    
    // Calculate utilization (average of both radios)
    double utilization = 0;
    int radioCount = 0;
    
    if (radio24GHz?.channelUtilizationPercent != null) {
      utilization += radio24GHz!.channelUtilizationPercent!;
      radioCount++;
    }
    
    if (radio5GHz?.channelUtilizationPercent != null) {
      utilization += radio5GHz!.channelUtilizationPercent!;
      radioCount++;
    }
    
    final utilizationStr = radioCount > 0 
        ? '${(utilization / radioCount).round()}%' 
        : 'N/A';

    // Map status to color
    final statusColors = {
      'online': Colors.green,
      'warning': Colors.orange,
      'offline': Colors.red,
    };
    
    final statusColor = statusColors[status] ?? Colors.grey;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.router,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildApMetricRow(
              context,
              'Clients',
              clientCount.toString(),
              Icons.devices,
            ),
            _buildApMetricRow(
              context,
              '2.4GHz',
              channel24,
              Icons.wifi_tethering,
            ),
            _buildApMetricRow(
              context,
              '5GHz',
              channel5,
              Icons.wifi,
            ),
            _buildApMetricRow(
              context,
              'Utilization',
              utilizationStr,
              Icons.speed,
            ),
            
            // Health indicator
            if (radio24GHz?.health != null || radio5GHz?.health != null)
              _buildHealthIndicator(context, radio24GHz, radio5GHz),
              
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Show detailed view
                  },
                  child: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApMetricRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHealthIndicator(
    BuildContext context, 
    RadioData? radio24GHz, 
    RadioData? radio5GHz
  ) {
    // Get the overall health severity
    String severity = 'unknown';
    String healthValue = 'N/A';
    
    if (radio24GHz?.health != null && radio24GHz!.health!.containsKey('overall')) {
      final health = radio24GHz.health!['overall'];
      if (health is Map) {
        severity = health['severity'] ?? 'unknown';
        healthValue = health['value']?.toString() ?? 'N/A';
      }
    } else if (radio5GHz?.health != null && radio5GHz!.health!.containsKey('overall')) {
      final health = radio5GHz.health!['overall'];
      if (health is Map) {
        severity = health['severity'] ?? 'unknown';
        healthValue = health['value']?.toString() ?? 'N/A';
      }
    }
    
    final severityColors = {
      'good': Colors.green,
      'warning': Colors.orange,
      'critical': Colors.red,
    };
    
    final color = severityColors[severity] ?? Colors.grey;
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.health_and_safety,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            'Health',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  severity.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (healthValue != 'N/A') ...[
                  const SizedBox(width: 4),
                  Text(
                    '($healthValue)',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}