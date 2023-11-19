import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

import 'service/service.dart' as service;

@CloudFunction()
Future<Response> function(Request request) async {
  String output = '{}';
  try {
    output = await service.process();
  } catch (error, stackTrace) {
    // Handle or report the error accordingly.
    print('An error occurred: $error\n$stackTrace');
  }
  return Response.ok(output);
}
