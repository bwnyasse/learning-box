import 'package:flutter_moviesapp_demo_firebase_remote_config/models/MyGenre.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'genre_info_card.dart';

class MyGenres extends StatelessWidget {
  const MyGenres({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Genres",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        const GenreInfoCardGridView(),
      ],
    );
  }
}

class GenreInfoCardGridView extends StatelessWidget {
  const GenreInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyGenres.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => GenreInfoCard(info: demoMyGenres[index]),
    );
  }
}
