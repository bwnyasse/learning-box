import 'dart:io' show Platform;
import "package:path/path.dart" as Path;
import 'package:shelf_static/shelf_static.dart';
import 'package:redstone/server.dart' as Server;

List<Map> users = [
  {"id": "1", "username": "User1", "password": "123456",
    "type": "manager"},
  {"id": "2", "username": "User2", "password": "password",
    "type": "programmer"},
  {"id": "3", "username": "User3", "password": "12345",
    "type": "programmer"},
  {"id": "4", "username": "User4", "password": "qwerty",
    "type": "secretary"},
  {"id": "5", "username": "User5", "password": "123456789",
    "type": "secretary"}
];

void main() {
  final String _buildPath = Platform.script.resolve('../web/').toFilePath();
  Server.setShelfHandler(createStaticHandler(_buildPath,
      defaultDocument: "index.html"));

  Server.setupConsoleLog();
  Server.start();
}

@Server.Route("/hello")
String hello() {
  print("User soliciting greeting...");
  return "Hello, Browser!";
}

@Server.Route("/hi")
String hi() => "Hi, Browser!";

@Server.Route("/user/id/:id")
Map getUserByID(String id) {
  print("Searching for user with ID: $id");

  // convert the ID from String to int
  int index = int.parse(id, onError: (_) => null);

  // check for error
  if (index == null || index < 1 || index > users.length) {
    return error("Invalid ID");
  }

  // get user
  Map foundUser = users[index - 1];

  // return user
  return success("user", foundUser);
}


@Server.Route("/user/param")
Map getUserByIDParam(@Server.QueryParam("id") String userID) {
  return getUserByID(userID);
}

Map success(String messageType, payload) {
  return {
    "messageType": messageType,
    "payload": payload
  };
}

@Server.Route("/user/type/:type")
Map getUsersByType(String type) {
  print("Searching for users with type: $type");

  // find qualifying users
  List<Map> foundUsers = users.where(
      (Map user) => user['type'] == type
  ).toList();

  // check for error
  if (foundUsers.isEmpty) {
    return error("Invalid type");
  }

  // return list of users
  return success("users", foundUsers);
}

Map error(String errorMessage) {
  print(errorMessage);

  return {
    "messageType": "error",
    "error": errorMessage
  };
}