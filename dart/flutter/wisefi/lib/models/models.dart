class FortiAPData {
  final String? name;
  final String? serial;
  final String? status;
  final int? cpuUsage;
  final int? memFree;
  final int? memTotal;
  final String? connectionState;
  final List<RadioData>? radios;
  final DateTime? timestamp;
  // Location-related fields
  final String? dv_fortigate_customer_name;
  final String? dv_fortigate_name;
  final String? dv_location;
  final String? host;
  FortiAPData({
    this.name,
    this.serial,
    this.status,
    this.cpuUsage,
    this.memFree,
    this.memTotal,
    this.connectionState,
    this.radios,
    this.timestamp,
    this.dv_fortigate_customer_name,
    this.dv_fortigate_name,
    this.dv_location,
    this.host,
  });

  factory FortiAPData.fromJson(Map<String, dynamic> json) {
    List<RadioData>? radiosList;

    if (json['radio'] != null) {
      if (json['radio'] is List) {
        radiosList = List<RadioData>.from(
            json['radio'].map((x) => RadioData.fromJson(x)));
      } else if (json['radio'] is Map) {
        radiosList = [RadioData.fromJson(json['radio'])];
      }
    }

    return FortiAPData(
      name: json['name'],
      serial: json['serial'],
      status: json['status'],
      cpuUsage: json['cpu_usage'],
      memFree: json['mem_free'],
      memTotal: json['mem_total'],
      connectionState: json['connection_state'],
      radios: radiosList,
      timestamp: json['@timestamp'] != null
          ? DateTime.parse(json['@timestamp'])
          : null,
      dv_fortigate_customer_name: json['dv_fortigate_customer_name'],
      dv_fortigate_name: json['dv_fortigate_name'],
      dv_location: json['dv_location'],
      host: json['host'],
    );
  }
}

class RadioData {
  final String? radioType;
  final int? clientCount;
  final int? channelUtilizationPercent;
  final int? interferingAps;
  final int? detectedRogueAps;
  final int? noiseFloor;
  final Map<String, dynamic>? health;
  final int? operChan;
  final int? bandwidthRx;
  final int? bandwidthTx;

  RadioData({
    this.radioType,
    this.clientCount,
    this.channelUtilizationPercent,
    this.interferingAps,
    this.detectedRogueAps,
    this.noiseFloor,
    this.health,
    this.operChan,
    this.bandwidthRx,
    this.bandwidthTx,
  });

  factory RadioData.fromJson(Map<String, dynamic> json) {
    return RadioData(
      radioType: json['radio_type'],
      clientCount: json['client_count'],
      channelUtilizationPercent: json['channel_utilization_percent'],
      interferingAps: json['interfering_aps'],
      detectedRogueAps: json['detected_rogue_aps'],
      noiseFloor: json['noise_floor'],
      health: json['health'],
      operChan: json['oper_chan'],
      bandwidthRx: json['bandwidth_rx'],
      bandwidthTx: json['bandwidth_tx'],
    );
  }

  // Helper method to get health severity for a specific metric
  String getHealthSeverity(String metric) {
    if (health == null || !health!.containsKey(metric)) {
      return 'unknown';
    }

    final metricData = health![metric];
    if (metricData is Map && metricData.containsKey('severity')) {
      return metricData['severity'];
    }

    return 'unknown';
  }

  // Helper method to get health value for a specific metric
  int getHealthValue(String metric) {
    if (health == null || !health!.containsKey(metric)) {
      return 0;
    }

    final metricData = health![metric];
    if (metricData is Map && metricData.containsKey('value')) {
      return metricData['value'] ?? 0;
    }

    return 0;
  }
}

class FortiManagerData {
  final String? action;
  final String? level;
  final String? msg;
  final String? status;
  final String? result;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? dev;
  final DateTime? date;
  final String? changes;

  FortiManagerData({
    this.action,
    this.level,
    this.msg,
    this.status,
    this.result,
    this.user,
    this.dev,
    this.date,
    this.changes,
  });

  factory FortiManagerData.fromJson(Map<String, dynamic> json) {
    return FortiManagerData(
      action: json['fortimanager']?['log']?['action'],
      level: json['fortimanager']?['log']?['level'],
      msg: json['fortimanager']?['log']?['msg'],
      status: json['fortimanager']?['log']?['status'],
      result: json['fortimanager']?['log']?['result'],
      user: json['fortimanager']?['log']?['user'],
      dev: json['fortimanager']?['log']?['dev'],
      date: json['fortimanager']?['log']?['date'] != null
          ? DateTime.parse(json['fortimanager']['log']['date'])
          : null,
      changes: json['fortimanager']?['log']?['changes'],
    );
  }

  String getUserName() {
    if (user != null && user!.containsKey('name')) {
      return user!['name'];
    }
    return 'Unknown User';
  }

  String getDeviceName() {
    if (dev != null && dev!.containsKey('name')) {
      return dev!['name'];
    }
    return 'Unknown Device';
  }
}
