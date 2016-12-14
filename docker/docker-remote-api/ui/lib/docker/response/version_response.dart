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


abstract class AsJsonReponse {

  Map _asJson;
  String _asPrettyJson;

  AsJsonReponse.fromJson(Map json, Version apiVersion) {
    _asJson = json;
    _asPrettyJson =new JsonEncoder.withIndent('  ').convert(json);
  }
}


class Version implements Comparable {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch) {
    if (major == null || major < 0) {
      throw new ArgumentError('"major" must not be null and must not be < 0.');
    }
    if (minor == null || minor < 0) {
      throw new ArgumentError('"minor" must not be null and must not be < 0.');
    }
    if (patch != null && patch < 0) {
      throw new ArgumentError('If "patch" is provided the value must be >= 0.');
    }
  }

  factory Version.fromString(String version) {
    assert(version != null && version.isNotEmpty);
    final parts = version.split('.');
    int major = 0;
    int minor = 0;
    int patch;

    if (parts.length < 2) {
      throw 'Unsupported version string format "${version}".';
    }

    if (parts.length >= 1) {
      major = int.parse(parts[0]);
    }
    if (parts.length >= 2) {
      minor = int.parse(parts[1]);
    }
    if (parts.length >= 3) {
      patch = int.parse(parts[2]);
    }
    if (parts.length >= 4) {
      throw 'Unsupported version string format "${version}".';
    }
    return new Version(major, minor, patch);
  }

  @override
  bool operator ==(other) {
    if (other is! Version) {
      return false;
    }
    final o = other as Version;
    return o.major == major &&
        o.minor == minor &&
        ((o.patch == null && patch == null) || (o.patch == patch));
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() => '${major}.${minor}${patch != null ? '.${patch}' : ''}';

  bool operator <(Version other) {
    assert(other != null);
    if (major < other.major) {
      return true;
    } else if (major > other.major) {
      return false;
    }
    if (minor < other.minor) {
      return true;
    } else if (minor > other.minor) {
      return false;
    }
    if (patch == null && other.patch == null) {
      return false;
    }
    if (patch == null || other.patch == null) {
      throw 'Only version with an equal number of parts can be compared.';
    }
    if (patch < other.patch) {
      return true;
    }
    return false;
  }

  bool operator >(Version other) {
    return other != this && !(this < other);
  }

  bool operator >=(Version other) {
    return this == other || this > other;
  }

  bool operator <=(Version other) {
    return this == other || this < other;
  }

  @override
  int compareTo(Version other) {
    if (this < other) {
      return -1;
    } else if (this == other) {
      return 0;
    }
    return 1;
  }

  static int compare(Comparable a, Comparable b) => a.compareTo(b);
}

/*
Example request: GET /version HTTP/1.1
Example response:

HTTP/1.1 200 OK
Content-Type: application/json

{
"Version": "1.12.0",
"Os": "linux",
"KernelVersion": "3.19.0-23-generic",
"GoVersion": "go1.6.3",
"GitCommit": "deadbee",
"Arch": "amd64",
"ApiVersion": "1.24",
"BuildTime": "2016-06-14T07:09:13.444803460+00:00",
"Experimental": true
}
*/
class VersionResponse extends AsJsonReponse{
  Version _version;
  Version get version => _version;

  String _os;
  String get os => _os;

  String _kernelVersion;
  String get kernelVersion => _kernelVersion;

  String _goVersion;
  String get goVersion => _goVersion;

  String _gitCommit;
  String get gitCommit => _gitCommit;

  String _architecture;
  String get architecture => _architecture;

  Version _apiVersion;
  Version get apiVersion => _apiVersion;


  VersionResponse.fromJson(Map json, Version apiVersion) : super.fromJson(json, apiVersion) {
    _version = new Version.fromString(json['Version']);
    _os = json['Os'];
    _kernelVersion = json['KernelVersion'];
    _goVersion = json['GoVersion'];
    _gitCommit = json['GitCommit'];
    _architecture = json['Arch'];
    _apiVersion = new Version.fromString(json['ApiVersion']);
  }
}