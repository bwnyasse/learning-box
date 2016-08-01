// Copyright (c) 2016, bwnyasse. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library shelf_with_test;

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_rest/shelf_rest.dart';

part '../lib/UserResource.dart';

void main(List<String> args) {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  final shelf.Handler handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_routeHandler());

  io.serve(handler, InternetAddress.LOOPBACK_IP_V4, port).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  }).catchError((error) => print(error));
}

_routeHandler() {
  var myRouter = router()..addAll(new UserResource(), path: 'users');
  return myRouter.handler;
}


shelf.Response _echoRequest(shelf.Request request) {
  return new shelf.Response.ok('Request for "${request.url}"');
}
