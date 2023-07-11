import 'dart:async';
import 'dart:convert';

import 'package:data_fetcher_service/utils/utils.dart';
import 'package:functions_framework/functions_framework.dart';
import 'models/models.dart';
import 'service/service.dart' as service;
import 'package:shelf/shelf.dart';

// Export models so builder can use them when generating `bin/server.dart`.
export 'models/models.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  return Response.ok('Cloud run with Dart Lang is OK !');
}
