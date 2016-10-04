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

@Component(
    selector: 'configuration-cmp',
    templateUrl:
    'packages/bw_dra/component/configuration_cmp.html',
    useShadowDom: false)
class ConfigurationCmp extends ShadowRootAware {

  DockerRemoteControler controler;
  String version;

  ConfigurationCmp(this.controler);

  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
  }

  updateConfig() async {
    await controler.load();
    version = controler.dockerRemoteConnections['http://192.168.1.19:2375']
        .dockerVersion.version;

    await controler.dockerRemoteConnections['http://192.168.1.19:2375'].info();

    print("LE");
    StreamSubscription eventsSubscription;
    eventsSubscription = controler.dockerRemoteConnections['http://192.168.1.19:2375'].events(filters: new EventsFilter()
      ..events.addAll(
          [ContainerEvent.stop, ContainerEvent.kill, ContainerEvent.die])).listen((event) {
      new Future.delayed(const Duration(milliseconds: 200), () async {
        print("ICI");
//        final Iterable<Container> containers = await connection.containers(
//            filters: {'status': [ContainerStatus.exited.toString()]});
//        if (containers.any((c) => c.id == createdResponse.container.id)) {
//          await connection.removeContainer(createdResponse.container);
//          eventsSubscription.cancel();
//        }
      });
    });
    controler.dockerRemoteConnections['http://192.168.1.19:2375'].events();
    print("LI");
  }
}