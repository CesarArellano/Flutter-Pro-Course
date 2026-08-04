import 'package:clappy/domain/entities/entities.dart';

abstract class SeriesDatasource {
  Future<List<TvShow>> getAiringToday({int page = 1});

  Future<List<TvShow>> getOnTheAir({int page = 1});

  Future<List<TvShow>> getPopular({int page = 1});

  Future<List<TvShow>> getTopRated({int page = 1});

  Future<TvShow> getSeriesById(String id);

  Future<List<Actor>> getCastBySeries(String seriesId);
}
