/**
 * Copyright (c) 2016 codelab-server. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 31/07/16
 * Author     : bwnyasse
 *  
 */
library piratesnest;

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'package:codelab_server/server/piratesapi.dart';

final ApiServer _apiServer = new ApiServer(prettyPrint: true);

main() async {
  // Add a bit of logging...
  Logger.root..level = Level.INFO
    ..onRecord.listen(print);

  // Set up a server serving the pirate API.
  _apiServer.addApi(new PiratesApi());
  HttpServer server =
  await HttpServer.bind(InternetAddress.ANY_IP_V4, 8088);
  server.listen(_apiServer.httpRequestHandler);
  print('Server listening on http://${server.address.host}:'
      '${server.port}');
}
