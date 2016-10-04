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
part of bw_dra;

abstract class AbstractHttpService {

  Future<HttpRequest> _get(String url) async => _performServerCall(url, 'GET');

  _performServerCall(String url, String m, {var sendData: null}) async {
    Future<HttpRequest> httpRequest;

    if (sendData == null) {
      httpRequest = HttpRequest.request(url, method: m);
    } else {
      httpRequest = HttpRequest.request(url, method: m, sendData: sendData,requestHeaders: addAcceptHeadersAsJson());
    }

    _addHttpRequestCatchError(httpRequest);

    return httpRequest;
  }

  _addHttpRequestCatchError(Future<HttpRequest> httpRequest) {
    // Handle Timeout
    // TODO: Handler Timeout ? maybe something wrong to call server
//    httpRequest.catchError((e) {
//      jsinterop.showNotieError('[ERROR]');
//    });
  }

  Map<String, String> addAcceptHeadersAsJson() =>
      {'Accept': 'application/json'};

  Map<String, String> addContentTypeHeadersAsJson() =>
      {'Content-Type': 'application/json'};
}