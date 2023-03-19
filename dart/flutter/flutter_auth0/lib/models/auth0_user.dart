import 'package:json_annotation/json_annotation.dart';

import 'auth0_permissions.dart';
import 'auth0_roles.dart';

part 'auth0_user.g.dart';

@JsonSerializable()
class Auth0User {
  Auth0User({
    required this.nickname,
    required this.name,
    required this.email,
    required this.picture,
    required this.updatedAt,
    required this.sub,
    required this.streamChatUserToken,
  });

  bool get hasImage => picture.isNotEmpty;

  final String nickname;
  final String name;
  final String picture;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'https://getstream.flutter_auth0.app/user_token')
  final String streamChatUserToken;

  // userID getter to understand it easier
  // GetStream doesn't not accept | in the userId, so we need to remove it
  String get id => sub.split('|').join('');
  final String sub;

  final String email;

  factory Auth0User.fromJson(Map<String, dynamic> json) =>
      _$Auth0UserFromJson(json);

  Map<String, dynamic> toJson() => _$Auth0UserToJson(this);
}
