import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'chart_component.dart';
import 'chart_info_card_component.dart';

class ChartDetailsComponent extends StatelessWidget {
  const ChartDetailsComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius:  BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Chart Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
             SizedBox(height: defaultPadding),
            ChartComponent(),
            ChartInfoCardComponent(
              svgSrc: "assets/flaticon/12.svg",
              title: "Adventure",
              average: "1.3",
              numOfMovies: 1328,
            ),
            ChartInfoCardComponent(
              svgSrc: "assets/flaticon/16.svg",
              title: "Animation",
              average: "15.3",
              numOfMovies: 1328,
            ),
            ChartInfoCardComponent(
              svgSrc: "assets/flaticon/27.svg",
              title: "Horror",
              average: "1.3",
              numOfMovies: 1328,
            ),
            ChartInfoCardComponent(
              svgSrc: "assets/icons/unknown.svg",
              title: "Unknown",
              average: "1.3",
              numOfMovies: 140,
            ),
          ],
        ),
      ),
    );
  }
}
