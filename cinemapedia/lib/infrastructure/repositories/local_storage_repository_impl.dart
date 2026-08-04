import 'package:clappy/domain/entities/movie.dart';
import 'package:clappy/domain/repositories/local_storage_repository.dart';
import 'package:clappy/infrastructure/datasources/drift_datasource.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  LocalStorageRepositoryImpl(this.datasource);
  final DriftDatasource datasource;

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) {
    return datasource.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return datasource.toggleFavorite(movie);
  }
}
