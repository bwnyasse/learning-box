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
library bwnyasse_chat_ng2_fb3;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';

import 'package:firebase3/firebase.dart' as fb;

@Component(
    selector: 'app-cmp',
    templateUrl: 'app_cmp.html',
    styleUrls: const ['app_cmp.css']
)
class AppCmp {

  AppCmp();
}