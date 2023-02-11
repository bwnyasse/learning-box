import 'package:flutter_moviesapp_demo_firebase_remote_config/constants.dart';
import 'package:flutter/material.dart';

class GenreInfo {
  final String? svgSrc, title;
  final int? numOfMovies, percentage;
  final Color? color;

  GenreInfo({
    this.svgSrc,
    this.title,
    this.numOfMovies,
    this.percentage,
    this.color,
  });
}

List demoMyGenres = [
  GenreInfo(
    title: "Adventure",
    numOfMovies: 10,
    svgSrc: "assets/flaticon/12.svg",
    color: primaryColor,
    percentage: 35,
  ),
  GenreInfo(
    title: "Animation",
    numOfMovies: 15,
    svgSrc: "assets/flaticon/16.svg",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  GenreInfo(
    title: "Horror",
    numOfMovies: 20,
    svgSrc: "assets/flaticon/27.svg",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  GenreInfo(
    title: "Action",
    numOfMovies: 2,
    svgSrc: "assets/flaticon/28.svg",
    color: Color(0xFF007EE5),
    percentage: 78,
  ),
];
