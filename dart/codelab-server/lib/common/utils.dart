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

library pirate.utils;

import 'dart:math' show Random;

import 'messages.dart';

// Proper pirate names.
const List<String> pirateNames = const [
  "Anne", "Bette", "Cate", "Dawn", "Elise", "Faye", "Ginger",
  "Harriot", "Izzy", "Jane", "Kaye", "Liz", "Maria", "Nell",
  "Olive", "Pat", "Queenie", "Rae", "Sal", "Tam", "Uma",
  "Violet", "Wilma", "Xana", "Yvonne", "Zelda", "Abe",
  "Billy", "Caleb", "Davie", "Eb", "Frank", "Gabe", "House",
  "Icarus", "Jack", "Kurt", "Larry", "Mike", "Nolan",
  "Oliver", "Pat", "Quib", "Roy", "Sal", "Tom", "Ube",
  "Val", "Walt", "Xavier", "Yvan", "Zeb"
];

// Proper pirate appellations.
const List<String> pirateAppellations = const [
  "Awesome", "Captain", "Even", "Fighter", "Great",
  "Hearty", "Jackal", "King", "Lord", "Mighty",
  "Noble", "Old", "Powerful", "Quick", "Red",
  "Stalwart", "Tank", "Ultimate", "Vicious",
  "Wily", "aXe", "Young", "Brave", "Eager",
  "Kind", "Sandy", "Xeric", "Yellow", "Zesty"
];

// Clearly invalid pirate appellations.
const List<String> _forbiddenAppellations = const [
  '', 'sweet', 'handsome', 'beautiful', 'weak', 'wuss',
  'chicken', 'fearful'
];

// Helper method for validating whether the given pirate is truly a pirate!
bool truePirate(Pirate pirate) => pirate.name != null &&
    pirate.name.trim().isNotEmpty &&
    pirate.appellation != null &&
    !_forbiddenAppellations
        .contains(pirate.appellation.toLowerCase());

// Shared class for shanghaiing (generating) pirates.
class PirateShanghaier {
  static final Random indexGen = new Random();

  Pirate shanghaiAPirate({String name, String appellation}) {
    var pirate = new Pirate();
    pirate.name = name != null
        ? name
        : pirateNames[indexGen.nextInt(pirateNames.length)];
    pirate.appellation = appellation != null
        ? appellation
        : pirateAppellations[
    indexGen.nextInt(pirateAppellations.length)];
    return truePirate(pirate) ? pirate : null;
  }
}