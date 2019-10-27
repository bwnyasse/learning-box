import 'package:equatable/equatable.dart';
import 'package:flutter_weather/src/blocs/settings/settings_event.dart';
import 'package:meta/meta.dart';

class SettingsState extends Equatable {
  final TemperatureUnits temperatureUnits;

  const SettingsState({@required this.temperatureUnits})
      : assert(temperatureUnits != null);

  @override
  List<Object> get props => [temperatureUnits];
}
