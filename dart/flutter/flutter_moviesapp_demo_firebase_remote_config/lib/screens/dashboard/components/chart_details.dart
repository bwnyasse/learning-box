import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'chart_info_card.dart';

class ChartDetails extends StatelessWidget {
  const ChartDetails({
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
            Chart(),
            ChartInfoCard(
              svgSrc: "assets/flaticon/12.svg",
              title: "Adventure",
              amountOfFiles: "1.3GB",
              numOfFiles: 1328,
            ),
            ChartInfoCard(
              svgSrc: "assets/flaticon/16.svg",
              title: "Animation",
              amountOfFiles: "15.3GB",
              numOfFiles: 1328,
            ),
            ChartInfoCard(
              svgSrc: "assets/flaticon/27.svg",
              title: "Horror",
              amountOfFiles: "1.3GB",
              numOfFiles: 1328,
            ),
            ChartInfoCard(
              svgSrc: "assets/icons/unknown.svg",
              title: "Unknown",
              amountOfFiles: "1.3GB",
              numOfFiles: 140,
            ),
          ],
        ),
      ),
    );
  }
}
