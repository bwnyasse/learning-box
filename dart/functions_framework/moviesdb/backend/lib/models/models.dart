import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'models.g.dart';

@JsonSerializable()
class MovieRequest {
  final String? isoCode;

  MovieRequest({this.isoCode});

  factory MovieRequest.fromJson(Map<String, dynamic> json) =>
      _$MovieRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRequestToJson(this);
}

@JsonSerializable()
class MoviesResponse extends Equatable {
  final int page;

  @JsonKey(name: 'total_results')
  final int totalResults;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'results')
  final List<Movie> movies;

  MoviesResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.movies,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);

  @override
  List<Object> get props => [
        this.page,
        this.totalPages,
        this.totalResults,
        this.movies,
      ];
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

  @JsonKey(name: 'gender_ids')
  final List genreIds = [];

  @JsonKey(name: 'backdrop_path', defaultValue: '')
  final String backdropPath;

  final double popularity;

  @JsonKey(name: 'release_date')
  final String releaseDate;

  Movie({
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
    required this.backdropPath,
    required this.popularity,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.video,
        this.voteCount,
        this.voteAverage,
        this.title,
        this.posterPath,
        this.originalLanguage,
        this.originalTitle,
        this.adult,
        this.overview,
        this.backdropPath,
        this.popularity,
        this.releaseDate,
      ];

  String get posterPathResolved => posterPath == null
      ? 'https://via.placeholder.com/300'
      : 'http://image.tmdb.org/t/p/w185/$posterPath';
}
