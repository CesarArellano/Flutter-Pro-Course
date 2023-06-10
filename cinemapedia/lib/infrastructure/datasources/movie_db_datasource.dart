import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';
import '../../domain/datasources/movies_datasource.dart';
import '../../domain/entities/movie.dart';
import '../mappers/movie_mapper.dart';
import '../models/moviedb/moviedb_response.dart';

class MovieDbDatasource implements MoviesDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX',
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');

    final MovieDbResponse movieDbResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDbResponse.results
    .map(
      (movieDb) => MovieMapper.movieDBToEntity(movieDb)
    )
    .where((movieDb) => movieDb.posterPath != 'no-poster').toList();

    return movies;
  }

}