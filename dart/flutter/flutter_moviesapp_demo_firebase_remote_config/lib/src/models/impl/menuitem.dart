import 'package:json_annotation/json_annotation.dart';

part 'menuitem.g.dart';

@JsonSerializable()
class MenuItemResponse {
  final String title;
  final List<MenuItem> items;

  MenuItemResponse({required this.title, required this.items});

  factory MenuItemResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuItemResponseFromJson(json);
}

@JsonSerializable()
class MenuItem {
  final int id;
  final String name;
  final String path;

  MenuItem({
    required this.id,
    required this.name,
    required this.path,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
