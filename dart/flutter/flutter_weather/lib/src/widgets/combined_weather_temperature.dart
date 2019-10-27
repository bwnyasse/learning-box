import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_weather/src/blocs/blocs.dart';
import 'package:flutter_weather/src/models/models.dart' as model;
import 'package:flutter_weather/src/widgets/widgets.dart';

class CombinedWeatherTemperature extends StatelessWidget {
  final model.ConsolidatedWeather weather;

  CombinedWeatherTemperature({
    Key key,
    @required this.weather,
  })  : assert(weather != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: WeatherConditions(condition: weather.getCondition()),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return Temperature(
                    temperature: weather.temp,
                    high: weather.maxTemp,
                    low: weather.minTemp,
                    units: state.temperatureUnits,
                  );
                },
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            weather.weatherStateName,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
