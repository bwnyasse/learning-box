// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menuitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemResponse _$MenuItemResponseFromJson(Map<String, dynamic> json) =>
    MenuItemResponse(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuItemResponseToJson(MenuItemResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      path: json['path'] as String,
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
    };
