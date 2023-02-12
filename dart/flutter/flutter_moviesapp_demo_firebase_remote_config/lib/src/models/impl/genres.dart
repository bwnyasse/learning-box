import 'package:flutter/material.dart';

import '../../constants.dart';

List mockMyGenres = [
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
    color: const Color(0xFFFFA113),
    percentage: 35,
  ),
  GenreInfo(
    title: "Horror",
    numOfMovies: 20,
    svgSrc: "assets/flaticon/27.svg",
    color: const Color(0xFFA4CDFF),
    percentage: 10,
  ),
  GenreInfo(
    title: "Action",
    numOfMovies: 2,
    svgSrc: "assets/flaticon/28.svg",
    color: const Color(0xFF007EE5),
    percentage: 78,
  ),
];

List<Genre> genres = [
  Genre(id: 16, name: "Animation"),
  Genre(id: 27, name: "Horror"),
  Genre(id: 28, name: "Action"),
  Genre(id: 35, name: "Comedy"),
  Genre(id: 53, name: "Thriller"),
  Genre(id: 80, name: "Crime"),
  Genre(id: 99, name: "Documentary"),
  Genre(id: 18, name: "Drama"),
  Genre(id: 10751, name: "Family"),
  Genre(id: 14, name: "Fantasy"),
  Genre(id: 36, name: "History"),
  Genre(id: 10402, name: "Music"),
  Genre(id: 9648, name: "Mystery"),
  Genre(id: 10749, name: "Romance"),
  Genre(id: 878, name: "Science Fiction"),
  Genre(id: 10770, name: "TV Movie"),
  Genre(id: 10752, name: "War"),
  Genre(id: 37, name: "Western"),
];

class Genre {
  final int id;
  final String name;
  Genre({
    required this.id,
    required this.name,
  });

  String get svg => "assets/flaticon/12.svg";
}

class GenreInfo implements Comparable<GenreInfo> {
  final String svgSrc, title;
  final int numOfMovies, percentage;
  final Color color;

  GenreInfo({
    required this.svgSrc,
    required this.title,
    required this.numOfMovies,
    required this.percentage,
    required this.color,
  });
  
  @override
  int compareTo(GenreInfo other) => other.numOfMovies!.compareTo(numOfMovies!.toInt());
}

