
import 'package:cinemapedia/infrastructure/datasources/movie_db_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movies_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Inmutable Repository
final moviesRepositoryProvider = Provider<MoviesRepositoryImpl>((ref) {
  return MoviesRepositoryImpl( MovieDbDatasource() );
});