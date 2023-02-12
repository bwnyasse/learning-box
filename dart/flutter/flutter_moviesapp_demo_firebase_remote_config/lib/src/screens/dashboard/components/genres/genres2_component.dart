import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/genres.dart';

import '../../../../constants.dart';
import '../../../../models/models.dart';
import 'genre2_info_card_component.dart';
import 'genre_info_card_component.dart';

class Genres2Component extends StatelessWidget {
  final List<Movie> movies;
  final int crossAxisCount;
  final double childAspectRatio;

  const Genres2Component({
    Key? key,
    required this.movies,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          Genre2InfoCardComponent(info: movies[index]),
    );
  }
}
