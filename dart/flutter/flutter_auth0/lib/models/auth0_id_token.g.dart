// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth0_id_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth0IdToken _$Auth0IdTokenFromJson(Map<String, dynamic> json) {
  return Auth0IdToken(
    nickname: json['nickname'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    picture: json['picture'] as String,
    updatedAt: json['updated_at'] as String,
    iss: json['iss'] as String,
    sub: json['sub'] as String,
    aud: json['aud'] as String,
    iat: json['iat'] as int,
    exp: json['exp'] as int,
    authTime: json['auth_time'] as int?,
    streamChatUserToken:
        json['https://getstream.flutter_auth0.app/user_token'] as String,
    roles: (json['https://users.flutter_auth0.app/roles'] as List<dynamic>)
        .map((e) => Auth0Role.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions:
        (json['https://users.flutter_auth0.app/permissions'] as List<dynamic>)
            .map((e) => Auth0Permission.fromJson(e as Map<String, dynamic>))
            .toList(),
  );
}

Map<String, dynamic> _$Auth0IdTokenToJson(Auth0IdToken instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'name': instance.name,
      'picture': instance.picture,
      'updated_at': instance.updatedAt,
      'iss': instance.iss,
      'sub': instance.sub,
      'aud': instance.aud,
      'email': instance.email,
      'iat': instance.iat,
      'exp': instance.exp,
      'auth_time': instance.authTime,
      'https://getstream.flutter_auth0.app/user_token':
          instance.streamChatUserToken,
      'https://users.flutter_auth0.app/roles': instance.roles,
      'https://users.flutter_auth0.app/permissions': instance.permissions,
    };
