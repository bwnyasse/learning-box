import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/src/models/models.dart';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class WeatherChanged extends ThemeEvent {
  final WeatherCondition condition;

  const WeatherChanged({@required this.condition}) : assert(condition != null);

  @override
  List<Object> get props => [condition];
}
