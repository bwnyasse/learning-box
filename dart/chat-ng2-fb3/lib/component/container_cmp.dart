/**
 * Copyright (c) 2016 chat-ng2-fb3. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 13/11/16
 * Author     : bwnyasse
 *  
 */

import 'dart:html';

import 'package:angular2/core.dart';

import '../app_header/app_header.dart';
import '../../services/firebase_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [AppHeader],
    providers: const [FirebaseService],
    styleUrls: const ['app_component.css']
)
class ContainerCmp {
  final FirebaseService fbService;

  AppComponent(FirebaseService this.fbService);
}