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

@Injectable()
class DockerRemoteControler {

  Map<String, DockerRemoteConnection> dockerRemoteConnections = new Map();

  Future<DockerRemoteConnection> load(Uri hostServer) async {
    DockerRemoteConnection connection = new DockerRemoteConnection(hostServer, new BrowserClient());
    dockerRemoteConnections[hostServer.toString()] = connection;
    await connection.init();
    return connection;
  }

}