/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 01/10/16
 * Author     : bwnyasse
 *  
 */

part of bw_dra;

/// Base class for all kinds of Docker events
abstract class DockerEventBase {
  const DockerEventBase();
}


/// An item of the response to the events request.
class EventsResponse {
  DockerEventBase _status;
  DockerEventBase get status => _status;

  String _id;
  String get id => _id;

  String _from;
  String get from => _from;

  DateTime _time;
  DateTime get time => _time;

  EventsResponse.fromJson(Map json) {
    if (json['status'] != null) {
      try {
        _status = DockerEvent.values
            .firstWhere((e) => e.toString() == json['status']);
      } catch (e) {
        print('${e}');
      }
    }
    _id = json['id'];
    _from = json['from'];
    _time = _parseDate(json['time']);
  }
}

/// Container related Docker events
/// [More details about container events](https://docs.docker.com/reference/api/images/event_state.png)
class ContainerEvent extends DockerEventBase {
  static const create = const ContainerEvent._(1, 'create');
  static const destroy = const ContainerEvent._(2, 'destroy');
  static const die = const ContainerEvent._(3, 'die');
  static const execCreate = const ContainerEvent._(4, 'exec_create');
  static const execStart = const ContainerEvent._(5, 'exec_start');
  static const export = const ContainerEvent._(6, 'export');
  static const kill = const ContainerEvent._(7, 'kill');
  static const outOfMemory = const ContainerEvent._(7, 'oom');
  static const pause = const ContainerEvent._(8, 'pause');
  static const restart = const ContainerEvent._(9, 'restart');
  static const start = const ContainerEvent._(10, 'start');
  static const stop = const ContainerEvent._(11, 'stop');
  static const unpause = const ContainerEvent._(11, 'unpause');

  static const values = const [
    create,
    destroy,
    die,
    execCreate,
    execStart,
    export,
    kill,
    outOfMemory,
    pause,
    restart,
    start,
    stop,
    unpause
  ];

  final int value;
  final String _asString;

  const ContainerEvent._(this.value, this._asString) : super();

  @override
  String toString() => _asString;
}

/// Image related Docker events
class ImageEvent extends DockerEventBase {
  static const untag = const ImageEvent._(101, 'untag');
  static const delete = const ImageEvent._(102, 'delete');

  static const values = const [untag, delete];

  final int value;
  final String _asString;

  const ImageEvent._(this.value, this._asString) : super();

  @override
  String toString() => _asString;
}

/// The filter argument to the events request.
class EventsFilter {
  final List<DockerEventBase> events = [];
  final List<Image> images = [];
  final List<Container> containers = [];

  Map toJson() {
    final json = {};
    if (events.isNotEmpty) {
      json['event'] = events.map((e) => e.toString()).toList();
    }
    if (images.isNotEmpty) {
      json['image'] = images.map((e) => e.name).toList();
    }
    if (containers.isNotEmpty) {
      json['container'] = containers.map((e) => e.id).toList();
    }
    return json;
  }
}

/// All Docker events in one enum
class DockerEvent {
  static const containerCreate = ContainerEvent.create;
  static const containerDestroy = ContainerEvent.destroy;
  static const containerDie = ContainerEvent.die;
  static const containerExecCreate = ContainerEvent.execCreate;
  static const containerExecStart = ContainerEvent.execStart;
  static const containerExport = ContainerEvent.export;
  static const containerKill = ContainerEvent.kill;
  static const containerOutOfMemory = ContainerEvent.outOfMemory;
  static const containerPause = ContainerEvent.pause;
  static const containerRestart = ContainerEvent.restart;
  static const containerStart = ContainerEvent.start;
  static const containerStop = ContainerEvent.stop;
  static const containerUnpause = ContainerEvent.unpause;

  static const imageUntag = ImageEvent.untag;
  static const imageDelete = ImageEvent.delete;

  static const values = const [
    containerCreate,
    containerDestroy,
    containerDie,
    containerExecCreate,
    containerExecStart,
    containerExport,
    containerKill,
    containerOutOfMemory,
    containerPause,
    containerRestart,
    containerStart,
    containerStop,
    containerUnpause,
    imageUntag,
    imageDelete,
  ];

  final DockerEvent value;
  const DockerEvent(this.value);
  @override toString() => value.toString();
}

/// A reference to an image.
class Image {
  final String name;

  Image(this.name) {
    assert(name != null && name.isNotEmpty);
  }
}

/// Basic info about a container.
class Container {
  String _id;
  String get id => _id;

  String _command;
  String get command => _command;

  DateTime _created;
  DateTime get created => _created;

  UnmodifiableMapView _labels;
  UnmodifiableMapView get labels => _labels;

  String _image;
  String get image => _image;

  List<String> _names;
  List<String> get names => _names;

  List<PortArgument> _ports;
  List<PortArgument> get ports => _ports;

  String _status;
  String get status => _status;

  Container(this._id);

  Container.fromJson(Map json) {
    _id = json['Id'];
    _command = json['Command'];
    _created = _parseDate(json['Created']);
    _labels = _parseLabels(json['Labels']);
    _image = json['Image'];
    _names = json['Names'];
    _ports = json['Ports'] == null
        ? null
        : json['Ports']
        .map((p) => new PortResponse.fromJson(p))
        .toList();
    _status = json['Status'];
  }

  Map toJson() {
    final json = {};
    if (id != null) json['Id'] = id;
    if (command != null) json['Command'] = command;
    if (created != null) json['Created'] = created.toIso8601String();
    if (image != null) json['Image'] = image;
    if (names != null) json['Names'] = names;
    if (ports != null) json['Ports'] = ports;
    if (status != null) json['Status'] = status;
    return json;
  }
}

class PortArgument {
  final String hostIp;
  final int host;
  final int container;
  final String name;
  const PortArgument(this.host, this.container, {this.name: null, this.hostIp});
  String toDockerArgument() {
    assert(container != null && container > 0);

    if (hostIp != null && hostIp.isNotEmpty) {
      if (host != null) {
        return '${hostIp}:${host}:${container}';
      } else {
        return '${hostIp}::${container}';
      }
    } else {
      if (host != null) {
        return '${host}:${container}';
      } else {
        return '${container}';
      }
    }
  }
}

class PortResponse {
  String _ip;
  String get ip => _ip;

  int _privatePort;
  int get privatePort => _privatePort;

  int _publicPort;
  int get publicPort => _publicPort;

  String _type;
  String get type => _type;

  PortResponse.fromJson(Map json) {
    if (json == null) {
      return;
    }
    _ip = json['IP'];
    _privatePort = json['PrivatePort'];
    _publicPort = json['PublicPort'];
    _type = json['Type'];
  }
}