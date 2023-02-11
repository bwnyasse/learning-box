import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/screens/dashboard/components/chart/chart_details_component.dart';

import '../../constants.dart';
import 'components/genres/genres_component.dart';
import 'components/header/header_component.dart';

import 'components/movies/movies_component.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                    children: const [
                      GenresComponent(),
                      SizedBox(height: defaultPadding),
                      MoviesComponent(),
                    ],
                  ),
                ),
                const SizedBox(width: defaultPadding),
                const Expanded(
                  flex: 2,
                  child: ChartDetailsComponent(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
