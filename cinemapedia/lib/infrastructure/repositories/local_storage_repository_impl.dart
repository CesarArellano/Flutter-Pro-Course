import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/isar_datasource.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  final IsarDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return datasource.loadMovies(
      limit: limit,
      offset: offset
    );
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return datasource.toggleFavorite(movie);
  }
  
}