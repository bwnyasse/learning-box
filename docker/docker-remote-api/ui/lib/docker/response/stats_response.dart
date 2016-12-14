/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 13/12/16
 * Author     : bwnyasse
 *  
 */
part of bw_dra;

class StatsResponse extends AsJsonReponse {

  DateTime _read;
  DateTime get read => _read;

  BlkIoStats _blkIoStats;

  BlkIoStats get blkIoStats => _blkIoStats;

  StatsResponseCpuStats _cpuStats;

  StatsResponseCpuStats get cpuStats => _cpuStats;

  StatsResponseMemoryStats _memoryStats;

  StatsResponseMemoryStats get memoryStats => _memoryStats;

  StatsResponseNetwork _network;

  StatsResponseNetwork get network => _network;

  StatsResponseCpuStats _preCpuStats;

  StatsResponseCpuStats get preCpuStats => _preCpuStats;



  StatsResponse.fromJson(Map json, Version apiVersion) : super.fromJson(json, apiVersion) {
    _read = _parseDate(json['read']);
    _blkIoStats = new BlkIoStats.fromJson(json['blkio_stats'], apiVersion);
    _cpuStats =
    new StatsResponseCpuStats.fromJson(json['cpu_stats'], apiVersion);
    _memoryStats =
    new StatsResponseMemoryStats.fromJson(json['memory_stats'], apiVersion);
//    _network = new StatsResponseNetwork.fromJson(json['network'], apiVersion);
    _preCpuStats =
    new StatsResponseCpuStats.fromJson(json['precpu_stats'], apiVersion);
  }
}

class BlkIoStats {
  UnmodifiableListView<int> _ioServiceBytesRecursive;
  UnmodifiableListView<int> get ioServiceBytesRecursive =>
      _ioServiceBytesRecursive;

  UnmodifiableListView<int> _ioServicedRecursive;
  UnmodifiableListView<int> get ioServicedRecursive => _ioServicedRecursive;

  UnmodifiableListView<int> _ioQueueRecursive;
  UnmodifiableListView<int> get ioQueueRecursive => _ioQueueRecursive;

  UnmodifiableListView<int> _ioServiceTimeRecursive;
  UnmodifiableListView<int> get ioServiceTimeRecursive =>
      _ioServiceTimeRecursive;

  UnmodifiableListView<int> _ioWaitTimeRecursive;
  UnmodifiableListView<int> get ioWaitTimeRecursive => _ioWaitTimeRecursive;

  UnmodifiableListView<int> _ioMergedRecursive;
  UnmodifiableListView<int> get ioMergedRecursive => _ioMergedRecursive;

  UnmodifiableListView<int> _ioTimeRecursive;
  UnmodifiableListView<int> get ioTimeRecursive => _ioTimeRecursive;

  UnmodifiableListView<int> _sectorsRecursive;
  UnmodifiableListView<int> get sectorsRecursive => _sectorsRecursive;

  BlkIoStats.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _ioServiceBytesRecursive =
        _toUnmodifiableListView(json['io_service_bytes_recursive']);
    _ioServicedRecursive =
        _toUnmodifiableListView(json['io_serviced_recursive']);
    _ioQueueRecursive = _toUnmodifiableListView(json['io_queue_recursive']);
    _ioServiceTimeRecursive =
        _toUnmodifiableListView(json['io_service_time_recursive']);
    _ioWaitTimeRecursive =
        _toUnmodifiableListView(json['io_wait_time_recursive']);
    _ioMergedRecursive = _toUnmodifiableListView(json['io_merged_recursive']);
    _ioTimeRecursive = _toUnmodifiableListView(json['io_time_recursive']);
    _sectorsRecursive = _toUnmodifiableListView(json['sectors_recursive']);

  }
}

class StatsResponseCpuStats {
  StatsResponseCpuUsage _cupUsage;
  StatsResponseCpuUsage get cupUsage => _cupUsage;

  int _systemCpuUsage;
  int get systemCpuUsage => _systemCpuUsage;

  ThrottlingData _throttlingData;
  ThrottlingData get throttlingData => _throttlingData;

  StatsResponseCpuStats.fromJson(Map json, Version apiVersion) {
    _cupUsage =
    new StatsResponseCpuUsage.fromJson(json['cpu_usage'], apiVersion);
    _systemCpuUsage = json['system_cpu_usage'];
    _throttlingData = new ThrottlingData.fromJson(json['throttling_data'], apiVersion);

  }
}

class StatsResponseMemoryStats {
  StatsResponseMemoryStatsStats _stats;
  StatsResponseMemoryStatsStats get stats => _stats;

  int _maxUsage;
  int get maxUsage => _maxUsage;

  int _usage;
  int get usage => _usage;

  int _failCount;
  int get failCount => _failCount;

  int _limit;
  int get limit => _limit;

  StatsResponseMemoryStats.fromJson(Map json, Version apiVersion) {
    _stats =
    new StatsResponseMemoryStatsStats.fromJson(json['stats'], apiVersion);
    _maxUsage = json['max_usage'];
    _usage = json['usage'];
    _failCount = json['failcnt'];
    _limit = json['limit'];
  }
}

class StatsResponseNetwork {
  int _rxDropped;
  int get rxDropped => _rxDropped;

  int _rxBytes;
  int get rxBytes => _rxBytes;

  int _rxErrors;
  int get rxErrors => _rxErrors;

  int _txPackets;
  int get txPackets => _txPackets;

  int _txDropped;
  int get txDropped => _txDropped;

  int _rxPackets;
  int get rxPackets => _rxPackets;

  int _txErrors;
  int get txErrors => _txErrors;

  int _txBytes;
  int get txBytes => _txBytes;

  StatsResponseNetwork.fromJson(Map json, Version apiVersion) {
    _rxDropped = json['rx_dropped'];
    _rxBytes = json['rx_bytes'];
    _rxErrors = json['rx_errors'];
    _txPackets = json['tx_packets'];
    _txDropped = json['tx_dropped'];
    _rxPackets = json['rx_packets'];
    _txErrors = json['tx_errors'];
    _txBytes = json['tx_bytes'];
  }
}

class StatsResponseMemoryStatsStats {
  int _totalPgmajFault;
  int get totalPgmajFault => _totalPgmajFault;

  int _cache;
  int get cache => _cache;

  int _mappedFile;
  int get mappedFile => _mappedFile;

  int _totalInactiveFile;
  int get totalInactiveFile => _totalInactiveFile;

  int _pgpgOut;
  int get pgpgOut => _pgpgOut;

  int _rss;
  int get rss => _rss;

  int _totalMappedFile;
  int get totalMappedFile => _totalMappedFile;

  int _writeBack;
  int get writeBack => _writeBack;

  int _unevictable;
  int get unevictable => _unevictable;

  int _pgpgIn;
  int get pgpgIn => _pgpgIn;

  int _totalUnevictable;
  int get totalUnevictable => _totalUnevictable;

  int _pgmajFault;
  int get pgmajFault => _pgmajFault;

  int _totalRss;
  int get totalRss => _totalRss;

  int _totalRssHuge;
  int get totalRssHuge => _totalRssHuge;

  int _totalWriteback;
  int get totalWriteback => _totalWriteback;

  int _totalInactiveAnon;
  int get totalInactiveAnon => _totalInactiveAnon;

  int _rssHuge;
  int get rssHuge => _rssHuge;

  int _hierarchicalMemoryLimit;
  int get hierarchicalMemoryLimit => _hierarchicalMemoryLimit;

  int _totalPgFault;
  int get totalPgFault => _totalPgFault;

  int _totalActiveFile;
  int get totalActiveFile => _totalActiveFile;

  int _activeAnon;
  int get activeAnon => _activeAnon;

  int _totalActiveAnon;
  int get totalActiveAnon => _totalActiveAnon;

  int _totalPgpgOut;
  int get totalPgpgOut => _totalPgpgOut;

  int _totalCache;
  int get totalCache => _totalCache;

  int _inactiveAnon;
  int get inactiveAnon => _inactiveAnon;

  int _activeFile;
  int get activeFile => _activeFile;

  int _pgFault;
  int get pgFault => _pgFault;

  int _inactiveFile;
  int get inactiveFile => _inactiveFile;

  int _totalPgpgIn;
  int get totalPgpgIn => _totalPgpgIn;

  StatsResponseMemoryStatsStats.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _totalPgmajFault = json['total_pgmajfault'];
    _cache = json['cache'];
    _mappedFile = json['mapped_file'];
    _totalInactiveFile = json['total_inactive_file'];
    _pgpgOut = json['pgpgout'];
    _rss = json['rss'];
    _totalMappedFile = json['total_mapped_file'];
    _writeBack = json['writeback'];
    _unevictable = json['unevictable'];
    _pgpgIn = json['pgpgin'];
    _totalUnevictable = json['total_unevictable'];
    _pgmajFault = json['pgmajfault'];
    _totalRss = json['total_rss'];
    _totalRssHuge = json['total_rss_huge'];
    _totalWriteback = json['total_writeback'];
    _totalInactiveAnon = json['total_inactive_anon'];
    _rssHuge = json['rss_huge'];
    _hierarchicalMemoryLimit = json['hierarchical_memory_limit'];
    _totalPgFault = json['total_pgfault'];
    _totalActiveFile = json['total_active_file'];
    _activeAnon = json['active_anon'];
    _totalActiveAnon = json['total_active_anon'];
    _totalPgpgOut = json['total_pgpgout'];
    _totalCache = json['total_cache'];
    _inactiveAnon = json['inactive_anon'];
    _activeFile = json['active_file'];
    _pgFault = json['pgfault'];
    _inactiveFile = json['inactive_file'];
    _totalPgpgIn = json['total_pgpgin'];

  }
}

class StatsResponseCpuUsage {
  UnmodifiableListView<int> _perCpuUsage;
  UnmodifiableListView<int> get perCpuUsage => _perCpuUsage;

  int _usageInUserMode;
  int get usageInUserMode => _usageInUserMode;

  int _totalUsage;
  int get totalUsage => _totalUsage;

  int _usageInKernelMode;
  int get usageInKernelMode => _usageInKernelMode;

  StatsResponseCpuUsage.fromJson(Map json, Version apiVersion) {
    _perCpuUsage = _toUnmodifiableListView(json['percpu_usage']);
    _usageInUserMode = json['usage_in_usermode'];
    _totalUsage = json['total_usage'];
    _usageInKernelMode = json['usage_in_kernelmode'];
  }
}

class ThrottlingData {
  int _periods;
  int get periods => _periods;

  int _throttledPeriods;
  int get throttledPeriods => _throttledPeriods;

  int _throttledTime;
  int get throttledTime => _throttledTime;

  ThrottlingData.fromJson(Map json, Version apiVersion) {
    _periods = json['periods'];
    _throttledPeriods = json['throttled_periods'];
    _throttledTime = json['throttled_time'];
  }
}