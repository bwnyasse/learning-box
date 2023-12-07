import 'dart:async';

import 'package:xterm/xterm.dart';

import 'main_module.dart';
import 'main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

final log = Logger('flutter_invoice_document_ai_ui');

void main() async {
  Logger.root.level = Level.ALL;
  runZonedGuarded(() {
    // This is the block of code that will be executed in a new zone with a custom error handler.
    _mainInZone();
  }, (error, stackTrace) {
    // This is the error handler that will be called if an error occurs in the block of code.
    log.severe('An error occurred: $error');
    log.severe('Stack trace: $stackTrace');
  });
}

void _mainInZone() async {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(ModularApp(
    module: MainModule(),
    child: const MainWidget(),
  ));
}
