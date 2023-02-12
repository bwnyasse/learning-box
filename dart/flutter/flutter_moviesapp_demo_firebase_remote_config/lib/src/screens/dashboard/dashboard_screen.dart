import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/movies.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/screens/dashboard/components/chart/chart_details_component.dart';

import '../../constants.dart';
import 'components/genres/genres2_component.dart';
import 'components/genres/genres_component.dart';
import 'components/header/header_component.dart';

import 'components/movies/movies_component.dart';

class DashboardScreen extends StatelessWidget {
  final MoviesResponse response;
  const DashboardScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const HeaderComponent(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                     //GenresComponent(genresInfo: response.genresInfo),
                     Genres2Component(movies: response.movies),
                     const SizedBox(height: defaultPadding),
                      MoviesComponent(movies: response.movies),
                    ],
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  flex: 2,
                  child: ChartDetailsComponent(genresInfo: response.genresInfo),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
