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
library bw_dra;

@MirrorsUsed(targets: const ['bw_dra'], override: '*')
import 'dart:mirrors';
import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:collection';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:quiver/collection.dart' as quiver_collection;
import 'package:quiver/core.dart' as quiver_core;
import 'package:date/date.dart' as external_date_lib;

part 'component/configuration_cmp.dart';
part 'injectable/abstract_http_service.dart';
part 'injectable/docker_remote_controler.dart';
part 'package:bw_dra/docker/docker_remote_connection.dart';

part 'docker/response/version_response.dart';
part 'docker/response/info_response.dart';
part 'docker/response/events_response.dart';

class ApplicationModule extends Module {
  ApplicationModule() {
    bind(ConfigurationCmp);
    bind(DockerRemoteControler);
  }
}