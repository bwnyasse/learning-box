/**
 * Copyright (c) 2016 shelf-with-test. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 01/08/16
 * Author     : bwnyasse
 *  
 */
part of shelf_with_test;

@RestResource('userId')
class UserResource {

  User find(String userId) {
    return new User.build();
  }
}


class User {
  final String userId;

  User.build({this.userId});

  User.fromJson(Map json) : this.userId = json['userId'];

  Map toJson() => {'userId': userId};
}