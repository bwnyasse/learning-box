/**
 * Copyright (c) 2016 codelab-server. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 31/07/16
 * Author     : bwnyasse
 *
 */
library pirate.server;

import 'package:rpc/rpc.dart';

import '../common/messages.dart';
import '../common/utils.dart';

// This class defines the interface that the server provides.
@ApiClass(version: 'v1')
class PiratesApi {
  final Map<String, Pirate> _pirateCrew = {};
  final PirateShanghaier _shanghaier = new PirateShanghaier();

  PiratesApi() {
    var captain = new Pirate.fromString('Lars the Captain');
    _pirateCrew[captain.toString()] = captain;
  }

  // Returns a list of the pirate crew.
  @ApiMethod(path: 'pirates')
  List<Pirate> listPirates() {
    return _pirateCrew.values.toList();
  }

  // Generates (shanghais) and returns a new pirate.
  // Does not add the new pirate to the crew.
  @ApiMethod(path: 'shanghai')
  Pirate shanghaiAPirate() {
    var pirate = _shanghaier.shanghaiAPirate();
    if (pirate == null) {
      throw new InternalServerError('Ran out of pirates!');
    }
    return pirate;
  }

  @ApiMethod(method: 'POST', path: 'pirate')
  Pirate hirePirate(Pirate newPirate) {
    if (!truePirate(newPirate)) {
      throw new BadRequestError(
          '$newPirate cannot be a pirate. \'This not a pirate name!');
    }
    var pirateName = newPirate.toString();
    if (_pirateCrew.containsKey(pirateName)) {
      throw new BadRequestError(
          '$newPirate is already part of your crew!');
    }

    // Add the pirate to the crew.
    _pirateCrew[pirateName] = newPirate;
    return newPirate;
  }

  @ApiMethod(
      method: 'DELETE', path: 'pirate/{name}/the/{appellation}')
  Pirate firePirate(String name, String appellation) {
    var pirate = new Pirate()
      ..name = Uri.decodeComponent(name)
      ..appellation = Uri.decodeComponent(appellation);
    var pirateName = pirate.toString();
    if (!_pirateCrew.containsKey(pirateName)) {
      throw new NotFoundError('Could not find pirate \'$pirate\'! ' +
          'Maybe they\'ve abandoned ship!');
    }
    return _pirateCrew.remove(pirateName);
  }


}