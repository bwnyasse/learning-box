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

class DockerRemoteConnection extends AbstractRequestService {

  VersionResponse _dockerVersion;
  VersionResponse get dockerVersion => _dockerVersion;

  DockerRemoteConnection(Uri hostServer,http.Client client) {
    assert(hostServer != null);
    assert(client != null);
    _serverReference = new ServerReference(hostServer, client);
  }

  Version get apiVersion {
    if (dockerVersion == null) {
      return null;
    }
    return dockerVersion.apiVersion;
  }

  /// Loads the version information from the Docker service.
  /// The version information is used to adapt to differences in the Docker
  /// remote API between different Docker version.
  /// If [init] isn't called no version specific handling can be done.
  Future init() async {
    if (_dockerVersion == null) {
      _dockerVersion = await version();
    }
  }

  /// Show Docker version information.
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Future<VersionResponse> version() async {
    final Map response = await _request(RequestType.get, '/version');
    return new VersionResponse.fromJson(response, apiVersion);
  }

  /// Get system-wide information.
  /// Status Codes:
  /// 200 - no error
  /// 500 - server error
  Future<InfoResponse> info() async {
    final Map response = await _request(RequestType.get, '/info');
    return new InfoResponse.fromJson(response, apiVersion);
  }

  /// This endpoint returns a live stream of a [container]'s resource usage
  /// statistics.
  ///
  /// [stream] - If `false` pull stats once then disconnect. Default [:true:]
  ///
  /// Note: this functionality currently only works when using the libcontainer
  /// exec-driver.
  ///
  /// Status Codes:
  /// 200 - no error
  /// 404 - no such container
  /// 500 - server error
  Stream<StatsResponse> stats(Container container, {bool stream: true}) async* {
    assert(
    container != null && container.id != null && container.id.isNotEmpty);
    assert(stream != null);
    final query = {};
    if (!stream) query['stream'] = stream.toString();

    final responseStream =  await _requestStream(
        RequestType.get, '/containers/${container.id}/stats', query: query);
    print(4);
    await for (var v in responseStream) {
      print(v);
      StatsResponse response = new StatsResponse.fromJson(JSON.decode(UTF8.decode(v)), apiVersion);
      yield response;
    }
  }
}

/// Error thrown
class DockerRemoteApiError {
  final int statusCode;
  final String reason;
  final String body;

  DockerRemoteApiError(this.statusCode, this.reason, this.body);

  @override
  String toString() =>
      '${super.toString()} - StatusCode: ${statusCode}, Reason: ${reason}, Body: ${body}';
}
