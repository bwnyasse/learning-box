import 'package:bloc/bloc.dart';
import 'package:flutter_weather/src/blocs/weather/weather_event.dart';
import 'package:flutter_weather/src/blocs/weather/weather_state.dart';
import 'package:flutter_weather/src/models/models.dart';
import 'package:flutter_weather/src/services/services.dart' show WeatherService;
import 'package:meta/meta.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService service;

  WeatherBloc({@required this.service}) : assert(service != null);

  @override
  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    //
    // FETCH
    //
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final Weather weather = await service.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (_) {
        yield WeatherError();
      }
    }

    //
    // REFRESH
    //
    if (event is RefreshWeather) {
      try {
        final Weather weather = await service.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (_) {
        yield state;
      }
    }
  }
}
