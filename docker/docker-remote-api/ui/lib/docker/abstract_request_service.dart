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

typedef String ResponsePreprocessor(String s);

class RequestType {
  static const post = const RequestType('POST');
  static const get = const RequestType('GET');

  final String value;

  const RequestType(this.value);

  @override
  String toString() => value;
}

class ResponseStream {
  StreamController<String> _dataFlow;

  ResponseStream() : _dataFlow = new StreamController();

  Stream<String> get flow => _dataFlow.stream.transform(new LineSplitter());

  void add(String data) => _dataFlow.add(data);
}

class ServerReference {
  final Uri uri;
  http.Client client;

  ServerReference(this.uri, [this.client]);

  Uri buildUri(String path, Map<String, String> queryParameters) {
    return new Uri(
        scheme: uri.scheme,
        userInfo: uri.userInfo,
        host: uri.host,
        port: uri.port,
        path: path,
        queryParameters: queryParameters);
  }
}

abstract class AbstractRequestService {

  final Map _headersJson = {'Content-Type': 'application/json'};
  final Map _headersTar = {'Content-Type': 'application/tar'};

  ServerReference _serverReference;

  ServerReference get serverReference => _serverReference;

  Future<dynamic> _request(RequestType requestType, String path,
      {Map body, Map query, Map<String,
          String> headers, ResponsePreprocessor preprocessor}) async {
    assert(requestType != null);
    assert(body == null);
    String data;
    if (body != null) {
      data = JSON.encode(body);
    }
    Map<String, String> _headers = headers != null ? headers : _headersJson;

    final url = serverReference.buildUri(path, query);

    http.Response response;
    switch (requestType) {
      case RequestType.get:
        response = await serverReference.client.get(url, headers: _headers);
        break;
      default:
        throw '"${requestType}" not implemented.';
    }

    if ((response.statusCode < 200 || response.statusCode >= 300) &&
        response.statusCode != 304) {
      throw new DockerRemoteApiError(
          response.statusCode, response.reasonPhrase, response.body);
    }
    if (response.body != null && response.body.isNotEmpty) {
      var data = response.body;
      if (preprocessor != null) {
        data = preprocessor(response.body);
      }
      try {
        return JSON.decode(data);
      } catch (e) {
        print(data);
      }
    }
    return null;
  }

  _requestStream2(){
    ResponseStream stream = new ResponseStream();
    stream.flow.listen((String data) {
      try{
        Map json = JSON.decode(data);
        StatsResponse statsResponse = new StatsResponse.fromJson(json,null);
        print(statsResponse._asJson);
      }catch(e){
        //Nothing to show if decode failed
      }
    });
    HttpRequest req = new HttpRequest();
    req.open('GET', 'http://vmi92598.contabo.host:4243/containers/f4cb/stats',
        async: true);
    req.onProgress.listen((ProgressEvent e) {
      stream.add(req.responseText);
    });
    req.send();
  }


  /// Post request expecting a streamed response.
  Future<Stream> _requestStream(RequestType requestType, String path, {Map body,
  Map<String, String> query, Map<String, String> headers}) async {

    assert(requestType != null);
    assert(requestType == RequestType.post || body == null);

    print("1");
    String data;
    if (body != null) {
      data = JSON.encode(body);
    }
    final url = serverReference.buildUri(path, query);

    final request = new http.Request(requestType.toString(), url)
      ..headers.addAll(headers != null ? headers : _headersJson);
    http_browser_client.BrowserClient client = new http_browser_client.BrowserClient();

    if (data != null) {
      request.body = data;
    }
    print("2");
    http.StreamedResponse response = await client.send(request);
    print("3");
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw new DockerRemoteApiError(
          response.statusCode, response.reasonPhrase, null);
    }
    return response.stream;
  }


  Future<HttpRequest> _httpRequestStream(RequestType requestType, String path, {Map body,
  Map<String, String> query, Map<String, String> headers}) async {

    assert(requestType != null);
    assert(requestType == RequestType.post || body == null);

    String data;
    if (body != null) {
      data = JSON.encode(body);
    }
    final url = serverReference.buildUri(path, query);

    final request = new http.Request(requestType.toString(), url)
      ..headers.addAll(headers != null ? headers : _headersJson);

    var requesHeaders = headers != null ? headers : _headersJson;
    print('url $url');
    final httpRequest = HttpRequest.request(url, method: 'POST', sendData: data,requestHeaders: requesHeaders());
    httpRequest.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status < 20 || request.status >= 30)) {
        throw new DockerRemoteApiError(
            request.statusCode, request.reasonPhrase, null);
      }
    });
    return httpRequest;
  }
}