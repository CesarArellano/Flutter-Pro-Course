import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';
import '../../domain/datasources/movies_datasource.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/video.dart';
import '../mappers/movie_mapper.dart';
import '../mappers/video_mapper.dart';
import '../models/moviedb/movie_details.dart';
import '../models/moviedb/moviedb_response.dart';
import '../models/moviedb/moviedb_videos.dart';

class MovieDbDatasource implements MoviesDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX',
    }
  ));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final MovieDbResponse movieDbResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDbResponse.results
    .map(
      (movieDb) => MovieMapper.movieDBToEntity(movieDb)
    )
    .where((movieDb) => movieDb.posterPath != 'no-poster').toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1 }) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {
        'page': page
      }
    );

    
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {
        'page': page
      }
    );

    
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {
        'page': page
      }
    );

    
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if( response.statusCode != 200 ) throw Exception('Movie with id: $id not found');

    final movieDetails = MovieDetails.fromJson(response.data);

    return MovieMapper.movieDetailsToEntity(movieDetails);
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    if( query.isEmpty ) return [];
    
    final response = await dio.get(
      '/search/movie',
      queryParameters: {
        'query': query
      }
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovies(response.data);
  }

  
  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if ( moviedbVideo.site == 'YouTube' ) {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }


}