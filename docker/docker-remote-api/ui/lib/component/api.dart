/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 14/12/16
 * Author     : bwnyasse
 *  
 */
import 'dart:html';
import 'dart:async';
import 'dart:convert';

class ResponseStream {
  StreamController<String> _dataFlow;

  ResponseStream() : _dataFlow = new StreamController();

  Stream<String> get flow => _dataFlow.stream.transform(new LineSplitter());

  void add(String data) => _dataFlow.add(data);
}

void main() {
  ResponseStream stream = new ResponseStream();
  stream.flow.listen((String data) {
    print(data);
  });

  HttpRequest req = new HttpRequest();
  req.open('GET', 'http://vmi92598.contabo.host:4243/containers/f4cb/stats',
      async: true);
  req.onProgress.listen((ProgressEvent e) {
    stream.add(req.responseText);
  });
  req.send();
}