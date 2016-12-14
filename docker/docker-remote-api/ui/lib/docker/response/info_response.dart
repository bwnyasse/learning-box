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

class RegistryConfigs {
  UnmodifiableMapView _indexConfigs;
  UnmodifiableMapView get indexConfigs => _indexConfigs;

  UnmodifiableListView<String> _insecureRegistryCidrs;
  UnmodifiableListView<String> get insecureRegistryCidrs =>
      _insecureRegistryCidrs;

  RegistryConfigs.fromJson(Map json) {
    if (json == null) {
      return;
    }

    _indexConfigs = _toUnmodifiableMapView(json['IndexConfigs']);
    _insecureRegistryCidrs =
        _toUnmodifiableListView(json['InsecureRegistryCIDRs']);
  }
}

/// Response to the info request.
class InfoResponse extends AsJsonReponse{
  int _containers;
  int get containers => _containers;

  bool _cpuCfsPeriod;
  bool get cpuCfsPeriod => _cpuCfsPeriod;

  bool _cpuCfsQuota;
  bool get cpuCfsQuota => _cpuCfsQuota;

  bool _debug;
  bool get debug => _debug;

  String _dockerRootDir;
  String get dockerRootDir => _dockerRootDir;

  String _driver;
  String get driver => _driver;

  UnmodifiableListView<List<List>> _driverStatus;
  UnmodifiableListView<List<List>> get driverStatus => _driverStatus;

  String _executionDriver;
  String get executionDriver => _executionDriver;

  bool _experimentalBuild;
  bool get experimentalBuild => _experimentalBuild;

  int _fdCount;
  int get fdCount => _fdCount;

  int _goroutinesCount;
  int get goroutinesCount => _goroutinesCount;

  String _httpProxy;
  String get httpProxy => _httpProxy;

  String _httpsProxy;
  String get httpsProxy => _httpsProxy;

  String _id;
  String get id => _id;

  int _images;
  int get images => _images;

  UnmodifiableListView<String> _indexServerAddress;
  UnmodifiableListView<String> get indexServerAddress => _indexServerAddress;

  String _initPath;
  String get initPath => _initPath;

  String _initSha1;
  String get initSha1 => _initSha1;

  bool _ipv4Forwarding;
  bool get ipv4Forwarding => _ipv4Forwarding;

  String _kernelVersion;
  String get kernelVersion => _kernelVersion;

  UnmodifiableMapView<String, String> _labels;
  UnmodifiableMapView<String, String> get labels => _labels;

  String _loggingDriver;
  String get loggingDriver => _loggingDriver;

  bool _memoryLimit;
  bool get memoryLimit => _memoryLimit;

  int _memTotal;
  int get memTotal => _memTotal;

  String _name;
  String get name => _name;

  int _cpuCount;
  int get cpuCount => _cpuCount;

  int _eventsListenersCount;
  int get eventsListenersCount => _eventsListenersCount;

  String _noProxy;
  String get noProxy => _noProxy;

  bool _oomKillDisable;
  bool get oomKillDisable => _oomKillDisable;

  String _operatingSystem;
  String get operatingSystem => _operatingSystem;

  RegistryConfigs _registryConfigs;
  RegistryConfigs get registryConfigs => _registryConfigs;

  bool _swapLimit;
  bool get swapLimit => _swapLimit;

  DateTime _systemTime;
  DateTime get systemTime => _systemTime;

  InfoResponse.fromJson(Map json, Version apiVersion) : super.fromJson(json, apiVersion) {
    _containers = json['Containers'];
    _cpuCfsPeriod = json['CpuCfsPeriod'];
    _cpuCfsQuota = json['CpuCfsQuota'];
    _debug = _parseBool(json['Debug']);
    _dockerRootDir = json['DockerRootDir'];
    _driver = json['Driver'];
    _driverStatus = _toUnmodifiableListView(json['DriverStatus']);
    _executionDriver = json['ExecutionDriver'];
    _experimentalBuild = json['ExperimentalBuild'];
    _httpProxy = json['HttpProxy'];
    _httpsProxy = json['HttpsProxy'];
    _id = json['ID'];
    _images = json['Images'];
    _indexServerAddress = json['IndexServerAddress'] is String
        ? _toUnmodifiableListView([json['IndexServerAddress']])
        : _toUnmodifiableListView(json['IndexServerAddress']);
    _initPath = json['InitPath'];
    _initSha1 = json['InitSha1'];
    _ipv4Forwarding = _parseBool(json['IPv4Forwarding']);
    _kernelVersion = json['KernelVersion'];
    _labels = _parseLabels(json['Labels']);
    _loggingDriver = json['LoggingDriver'];
    _memoryLimit = _parseBool(json['MemoryLimit']);
    _memTotal = json['MemTotal'];
    _name = json['Name'];
    _cpuCount = json['NCPU'];
    _eventsListenersCount = json['NEventsListener'];
    _fdCount = json['NFd'];
    _goroutinesCount = json['NGoroutines'];
    _noProxy = json['NoProxy'];
    _oomKillDisable = json['OomKillDisable'];
    _operatingSystem = json['OperatingSystem'];
    _registryConfigs =
    new RegistryConfigs.fromJson(json['RegistryConfigs']);
    _swapLimit = _parseBool(json['SwapLimit']);
    _systemTime = _parseDate(json['SystemTime']);

  }



}
Map<String, String> _parseLabels(Map<String, List<String>> json) {
  if (json == null) {
    return null;
  }
  final l =
  json['Labels'] != null ? json['Labels'].map((l) => l.split('=')) : null;
  return l == null
      ? null
      : _toUnmodifiableMapView(new Map.fromIterable(l,
      key: (l) => l[0], value: (l) => l.length == 2 ? l[1] : null));
}

UnmodifiableMapView _toUnmodifiableMapView(Map map) {
  if (map == null) {
    return null;
  }
  return new UnmodifiableMapView(new Map.fromIterable(map.keys,
      key: (k) => k, value: (k) {
        if (map == null) {
          return null;
        }
        if (map[k] is Map) {
          return _toUnmodifiableMapView(map[k]);
        } else if (map[k] is List) {
          return _toUnmodifiableListView(map[k]);
        } else {
          return map[k];
        }
      }));
}

UnmodifiableListView _toUnmodifiableListView(Iterable list) {
  if (list == null) {
    return null;
  }
  if (list.length == 0) {
    return new UnmodifiableListView(const []);
  }

  return new UnmodifiableListView(list.map((e) {
    if (e is Map) {
      return _toUnmodifiableMapView(e);
    } else if (e is List) {
      return _toUnmodifiableListView(e);
    } else {
      return e;
    }
  }).toList());
}

DateTime _parseDate(dynamic dateValue) {
  if (dateValue == null) {
    return null;
  }
  if (dateValue is String) {
    if (dateValue == '0001-01-01T00:00:00Z') {
      return new DateTime(1, 1, 1);
    }

    try {
      final years = int.parse((dateValue as String).substring(0, 4));
      final months = int.parse(dateValue.substring(5, 7));
      final days = int.parse(dateValue.substring(8, 10));
      final hours = int.parse(dateValue.substring(11, 13));
      final minutes = int.parse(dateValue.substring(14, 16));
      final seconds = int.parse(dateValue.substring(17, 19));
      final milliseconds = int.parse(dateValue.substring(20, 23));
      return new DateTime.utc(
          years, months, days, hours, minutes, seconds, milliseconds);
    } catch (_) {
      print('parsing "${dateValue}" failed.');
      rethrow;
    }
  } else if (dateValue is int) {
    return new DateTime.fromMillisecondsSinceEpoch(dateValue * 1000,
        isUtc: true);
  }
  throw 'Unsupported type "${dateValue.runtimeType}" passed.';
}

bool _parseBool(dynamic boolValue) {
  if (boolValue == null) {
    return null;
  }
  if (boolValue is bool) {
    return boolValue;
  }
  if (boolValue is int) {
    return boolValue == 1;
  }
  if (boolValue is String) {
    if (boolValue.toLowerCase() == 'true') {
      return true;
    } else if (boolValue.toLowerCase() == 'false') {
      return false;
    }
  }

  throw new FormatException(
      'Value "${boolValue}" can not be converted to bool.');
}