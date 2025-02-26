import 'package:wisefi/models/models.dart';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataService {
  Future<List<dynamic>> loadMockData(String filename) async {
    try {
      final jsonString = await rootBundle.loadString(filename);
      final jsonData = json.decode(jsonString);
      return jsonData is List ? jsonData : [jsonData];
    } catch (e) {
      print('Error loading mock data from $filename: $e');
      return [];
    }
  }

  Future<List<FortiAPData>> loadFortiAPData() async {
    try {
      final data = await loadMockData('assets/mocks/fortiap_data.json');
      return data.map((item) => FortiAPData.fromJson(item)).toList();
    } catch (e) {
      print('Error processing FortiAP data: $e');
      return [];
    }
  }

  Future<List<FortiManagerData>> loadFortiManagerData() async {
    try {
      final data = await loadMockData('assets/mocks/fortimanager_data.json');
      return data.map((item) => FortiManagerData.fromJson(item)).toList();
    } catch (e) {
      print('Error processing FortiManager data: $e');
      return [];
    }
  }

  // Generate sample FortiAP data for development
  List<FortiAPData> generateSampleFortiAPData() {
    final random = Random();
    final now = DateTime.now();

    return List.generate(10, (index) {
      final radioList = [
        RadioData(
          radioType: "2.4GHz",
          clientCount: random.nextInt(20) + 5,
          channelUtilizationPercent: random.nextInt(80) + 10,
          interferingAps: random.nextInt(5),
          detectedRogueAps: random.nextInt(3),
          noiseFloor: -1 * (random.nextInt(15) + 90),
          operChan: (index % 11) + 1,
          bandwidthRx: random.nextInt(50) + 10,
          bandwidthTx: random.nextInt(30) + 5,
          health: {
            "channel_utilization": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(100)
            },
            "client_count": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(50)
            },
            "interfering_ssids": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(10)
            },
            "overall": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(100)
            }
          },
        ),
        RadioData(
          radioType: "5GHz",
          clientCount: random.nextInt(30) + 10,
          channelUtilizationPercent: random.nextInt(60) + 5,
          interferingAps: random.nextInt(3),
          detectedRogueAps: random.nextInt(2),
          noiseFloor: -1 * (random.nextInt(10) + 95),
          operChan: 36 + (random.nextInt(12) * 4),
          bandwidthRx: random.nextInt(100) + 50,
          bandwidthTx: random.nextInt(80) + 30,
          health: {
            "channel_utilization": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(100)
            },
            "client_count": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(50)
            },
            "interfering_ssids": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(10)
            },
            "overall": {
              "severity": ["good", "warning", "critical"][random.nextInt(3)],
              "value": random.nextInt(100)
            }
          },
        ),
      ];

      return FortiAPData(
        name: "AP-${100 + index}",
        serial: "FAPVM${random.nextInt(9000) + 1000}",
        status: [
          "online",
          "online",
          "online",
          "warning",
          "offline"
        ][random.nextInt(5)],
        cpuUsage: random.nextInt(80) + 10,
        memFree: random.nextInt(512) + 256,
        memTotal: 1024,
        connectionState: [
          "connected",
          "connecting",
          "disconnected"
        ][random.nextInt(3)],
        radios: radioList,
        timestamp: now.subtract(Duration(minutes: random.nextInt(60))),
      );
    });
  }

  // Generate sample FortiManager data for development
  List<FortiManagerData> generateSampleFortiManagerData() {
    final random = Random();
    final now = DateTime.now();

    final actions = [
      "config_change",
      "login",
      "logout",
      "device_registration",
      "backup",
      "restore",
      "update",
      "reboot"
    ];

    final users = [
      {"id": "admin1", "name": "Administrator"},
      {"id": "jsmith", "name": "John Smith"},
      {"id": "mjones", "name": "Mary Jones"},
      {"id": "tadmin", "name": "Tech Admin"}
    ];

    final devices = [
      {"id": "FGT01", "name": "Fortigate-HQ"},
      {"id": "FGT02", "name": "Fortigate-Branch1"},
      {"id": "FAP01", "name": "FortiAP-Floor1"},
      {"id": "FAP02", "name": "FortiAP-Floor2"}
    ];

    final levels = ["information", "warning", "critical", "debug"];

    final results = ["success", "success", "success", "failure", "error"];

    final messages = [
      "Configuration changed on device",
      "User logged in successfully",
      "User logged out",
      "Device registered to FortiManager",
      "Backup completed successfully",
      "Failed to restore configuration",
      "Update applied to device",
      "Device rebooted successfully",
      "Connection to device failed"
    ];

    return List.generate(20, (index) {
      final actionIndex = random.nextInt(actions.length);
      final action = actions[actionIndex];

      // Generate a message relevant to the action
      String message = messages[random.nextInt(messages.length)];

      // Generate changes for config_change actions
      String? changes;
      if (action == "config_change") {
        changes =
            "Changed WiFi SSID name from 'Guest-Network' to 'Guest-WiFi'\nChanged password policy on admin accounts\nUpdated firewall rule for outbound traffic";
      }

      return FortiManagerData(
        action: action,
        level: levels[random.nextInt(levels.length)],
        msg: message,
        status: random.nextBool() ? "completed" : "in_progress",
        result: results[random.nextInt(results.length)],
        user: users[random.nextInt(users.length)],
        dev: devices[random.nextInt(devices.length)],
        date: now.subtract(Duration(hours: random.nextInt(72))),
        changes: changes,
      );
    });
  }
}
