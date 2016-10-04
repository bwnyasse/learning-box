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

  DockerRemoteControler() {
  }

  load() async {
    String hostServer = 'http://192.168.1.19:2375';
    DockerRemoteConnection connection = new DockerRemoteConnection(hostServer);
    await connection.init();
    dockerRemoteConnections[hostServer] = connection;
  }

}