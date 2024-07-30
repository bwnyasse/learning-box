import 'package:demo_macros/user.dart';

void main() {
// Given some arbitrary JSON:*
  var userJson = {
    'age': 5,
    'name': 'Roger',
    'username': 'roger1337',
  };
  // Use the generated members:*
  var user = User.fromJson(userJson);
  print(user);
  print(user.toJson());
}
