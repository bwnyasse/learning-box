import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/genres.dart';

import '../../../../constants.dart';
import 'genre_info_card_component.dart';

class GenresComponent extends StatelessWidget {
  final List<GenreInfo> genresInfo;
  final int crossAxisCount;
  final double childAspectRatio;

  const GenresComponent({
    Key? key,
    required this.genresInfo,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: genresInfo.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          GenreInfoCardComponent(info: genresInfo[index]),
    );
  }
}
