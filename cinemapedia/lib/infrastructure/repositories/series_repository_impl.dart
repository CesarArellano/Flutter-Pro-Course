import '../../domain/entities/actor.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/repositories/series_repository.dart';
import '../datasources/tv_moviedb_datasource.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  SeriesRepositoryImpl(this.datasource);

  final TvMovieDbDatasource datasource;

  @override
  Future<List<TvShow>> getAiringToday({int page = 1}) {
    return datasource.getAiringToday(page: page);
  }

  @override
  Future<List<TvShow>> getOnTheAir({int page = 1}) {
    return datasource.getOnTheAir(page: page);
  }

  @override
  Future<List<TvShow>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<TvShow>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<TvShow> getSeriesById(String id) {
    return datasource.getSeriesById(id);
  }

  @override
  Future<List<Actor>> getCastBySeries(String seriesId) {
    return datasource.getCastBySeries(seriesId);
  }
}
