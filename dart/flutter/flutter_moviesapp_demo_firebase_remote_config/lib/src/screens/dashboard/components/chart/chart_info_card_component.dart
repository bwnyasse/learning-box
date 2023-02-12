import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class ChartInfoCardComponent extends StatelessWidget {
  const ChartInfoCardComponent({
    Key? key,
    required this.title,
    required this.randomColor,
    required this.average,
    required this.numOfMovies,
  }) : super(key: key);
  final Color randomColor;
  final String title,  average;
  final int numOfMovies;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              height: 10,
              width: 10,
              decoration:  BoxDecoration(
                color: randomColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$numOfMovies Movies",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Text(average)
        ],
      ),
    );
  }
}
