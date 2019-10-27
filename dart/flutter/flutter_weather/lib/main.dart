import 'package:flutter/material.dart';
import 'package:flutter_weather/src/blocs/bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/src/blocs/blocs.dart';
import 'package:flutter_weather/src/services/services.dart';
import 'package:flutter_weather/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'src/providers/weather_provider.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    WeatherProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            builder: (context) => ThemeBloc(),
          ),
          BlocProvider<SettingsBloc>(
            builder: (context) => SettingsBloc(),
          ),
        ],
        child: WeatherApp(),
      ),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Flutter Weather',
          theme: themeState.theme,
          home: BlocProvider(
            builder: (context) => WeatherBloc(
                service: Provider.of<WeatherService>(context, listen: false)),
            child: WeatherEntryPoint(),
          ),
        );
      },
    );
  }
}
