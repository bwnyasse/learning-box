import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;

part 'movies.g.dart';

@JsonSerializable()
class MoviesResponse extends Equatable {
  final int page;

  @JsonKey(name: 'total_results')
  final int totalResults;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'results')
  final List<Movie> movies;

  late List<GenreInfo> genresInfo;

  MoviesResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.movies,
  }) {
    genresInfo = buildGenresInfo();
  }

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);

  @override
  List<Object> get props => [
        page,
        totalPages,
        totalResults,
        movies,
      ];

  List<GenreInfo> buildGenresInfo() {
    List<GenreInfo> results = [];
    for (var genre in genres) {
      List moviesWithThatGenre =
          movies.where((movie) => movie.genreIds.contains(genre.id)).toList();
      if (moviesWithThatGenre.isNotEmpty) {
        Color randomColor =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0);
        double percentage = moviesWithThatGenre.length * 100 / movies.length;
        results.add(GenreInfo(
            svgSrc: genre.svg,
            title: genre.name,
            numOfMovies: moviesWithThatGenre.length,
            percentage: percentage.toInt(),
            color: randomColor));
      }
    }
    results.sort();
    return results;
  }
}

@JsonSerializable()
class Movie extends Equatable {
  final int id;

  final bool video;

  @JsonKey(name: 'vote_count')
  final int voteCount;

  @JsonKey(name: 'vote_average')
  final double voteAverage;

  final String title;

  @JsonKey(name: 'poster_path')
  final String posterPath;

  @JsonKey(name: 'original_language')
  final String originalLanguage;

  @JsonKey(name: 'original_title')
  final String originalTitle;

  final bool adult;

  final String overview;

  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;

  @JsonKey(name: 'backdrop_path')
  final String backdropPath;

  final double popularity;

  @JsonKey(name: 'release_date')
  final String releaseDate;

  @JsonKey(defaultValue: false)
  final bool favorite;

  const Movie({
    required this.id,
    required this.video,
    required this.voteCount,
    required this.voteAverage,
    required this.title,
    required this.posterPath,
    required this.originalLanguage,
    required this.originalTitle,
    required this.adult,
    required this.overview,
    required this.genreIds,
    required this.backdropPath,
    required this.popularity,
    required this.releaseDate,
    required this.favorite,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  List<Object> get props => [
        id,
        video,
        voteCount,
        voteAverage,
        title,
        posterPath,
        originalLanguage,
        originalTitle,
        adult,
        overview,
        backdropPath,
        popularity,
        releaseDate,
        favorite,
      ];

  String get posterPathResolved => posterPath.isEmpty
      ? 'https://via.placeholder.com/300'
      : 'https://image.tmdb.org/t/p/w185/$posterPath';
}
