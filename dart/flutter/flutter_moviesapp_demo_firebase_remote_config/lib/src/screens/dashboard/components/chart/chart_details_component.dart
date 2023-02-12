import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/genres.dart';

import '../../../../constants.dart';
import 'chart_component.dart';
import 'chart_info_card_component.dart';

class ChartDetailsComponent extends StatelessWidget {
  final List<GenreInfo> genresInfo;

  const ChartDetailsComponent({super.key, required this.genresInfo});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chart Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ChartComponent(genresInfo: genresInfo),
            for (GenreInfo info in genresInfo)
              ChartInfoCardComponent(
                randomColor: info.color,
                title: info.title,
                average: "",
                numOfMovies: info.numOfMovies,
              ),
          ],
        ),
      ),
    );
  }
}
