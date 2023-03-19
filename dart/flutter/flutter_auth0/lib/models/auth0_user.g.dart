// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth0_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth0User _$Auth0UserFromJson(Map<String, dynamic> json) {
  return Auth0User(
    nickname: json['nickname'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    picture: json['picture'] as String,
    updatedAt: json['updated_at'] as String,
    sub: json['sub'] as String,
    streamChatUserToken:
        json['https://getstream.flutter_auth0.app/user_token'] as String,
  );
}

Map<String, dynamic> _$Auth0UserToJson(Auth0User instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'name': instance.name,
      'picture': instance.picture,
      'updated_at': instance.updatedAt,
      'https://getstream.flutter_auth0.app/user_token':
          instance.streamChatUserToken,
      'sub': instance.sub,
      'email': instance.email,
    };
