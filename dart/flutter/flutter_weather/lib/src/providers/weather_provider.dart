import 'package:flutter/material.dart';
import 'package:flutter_weather/src/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WeatherProvider extends StatelessWidget {
  final Widget child;

  WeatherProvider({@required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: WeatherApiClient(
            httpClient: http.Client(),
          ),
        ),
        ProxyProvider<WeatherApiClient, WeatherService>(
          builder: (c, apiClient, previousService) =>
              previousService ?? WeatherService(apiClient: apiClient),
        ),
      ],
      child: child,
    );
  }
}
