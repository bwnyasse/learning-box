import 'package:flutter/material.dart';

import '../../constants.dart';

class GenreInfo {
  final String? svgSrc, title;
  final int? numOfMovies, percentage;
  final Color? color;

  GenreInfo({
    required this.svgSrc,
    required this.title,
    required this.numOfMovies,
    required this.percentage,
    required this.color,
  });
}

