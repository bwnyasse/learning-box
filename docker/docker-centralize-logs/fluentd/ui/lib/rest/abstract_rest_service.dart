/**
 * Copyright (c) 2016 ui. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 05/08/16
 * Author     : bwnyasse
 *
 */
part of fluentd_log_explorer;

abstract class AbstractRestService {
  
  Future<HttpRequest> _get(String url) async => _performServerCall(url, 'GET');

  Future<HttpRequest> _head(String url) async => _performServerCall(url, 'HEAD');

  Future<HttpRequest> _post(String url, {var sendData}) async => _performServerCall(url, 'POST', sendData: sendData);

  _performServerCall(String url, String m, {var sendData: null}) async {
    Future<HttpRequest> httpRequest;

    if (sendData == null) {
      httpRequest = HttpRequest.request(url, method: m);
    } else {
      httpRequest = HttpRequest.request(url, method: m, sendData: sendData);
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

  Map<String, String> addAcceptHeadersAsJson() => {'Accept': 'application/json'};

  Map<String, String> addContentTypeHeadersAsJson() => {'Content-Type': 'application/json'};
}
