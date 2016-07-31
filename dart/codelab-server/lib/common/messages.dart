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

library pirate.messages;

// This class is used to send data back and forth between the
// client and server. It is automatically serialized and
// deserialized by the RPC package.
class Pirate {
  String name;
  String appellation;

  // A message class must have a default constructor taking no
  // arguments.
  Pirate();

  // It is fine to have other named constructors.
  Pirate.fromString(String pirateName) {
    var parts = pirateName.split(' the ');
    name = parts[0];
    appellation = parts[1];
  }

  String toString() => name.isEmpty ? '' : '$name the $appellation';
}
