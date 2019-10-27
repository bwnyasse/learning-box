import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final ThemeData theme;
  final MaterialColor color;

  const ThemeState({@required this.theme, @required this.color})
      : assert(theme != null),
        assert(color != null);

  @override
  List<Object> get props => [theme, color];
}
