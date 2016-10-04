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
import 'package:angular/application_factory.dart';
import 'package:bw_dra/application_module.dart';
import 'package:ng_infinite_scroll/ng_infinite_scroll.dart';

///
/// Project Entry point.
///
/// Define modules to be load.
///
void main() {
  applicationFactory()
    ..addModule(new ApplicationModule())
    ..addModule(new InfiniteScrollModule())
    ..run();
}
