import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {}

class TemperatureUnitsToggled extends SettingsEvent {
  @override
  List<Object> get props => [];
}

enum TemperatureUnits { fahrenheit, celsius }