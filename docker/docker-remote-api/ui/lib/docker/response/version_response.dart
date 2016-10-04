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
class VersionResponse {
  String _version;
  String get version => _version;

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

  String _apiVersion;
  String get apiVersion => _apiVersion;

  VersionResponse.fromJson(Map json) {
    _version = json['Version'];
    _os = json['Os'];
    _kernelVersion = json['KernelVersion'];
    _goVersion = json['GoVersion'];
    _gitCommit = json['GitCommit'];
    _architecture = json['Arch'];
    _apiVersion = json['ApiVersion'];
  }
}