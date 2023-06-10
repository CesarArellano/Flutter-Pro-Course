
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movie_db_datasource.dart';

class MoviesRepositoryImpl implements MoviesRepository {

  final MovieDbDatasource datasource;

  MoviesRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
  
}