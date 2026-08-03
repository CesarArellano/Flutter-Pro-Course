import '../../config/network/network_service.dart';
import '../../domain/datasources/series_datasource.dart';
import '../../domain/entities/actor.dart';
import '../../domain/entities/tv_show.dart';
import '../mappers/actor_mapper.dart';
import '../mappers/tv_mapper.dart';
import '../models/moviedb/credits_reponse.dart';
import '../models/moviedb/tv_details.dart';
import '../models/moviedb/tv_moviedb.dart';

class TvMovieDbDatasource implements SeriesDatasource {
  TvMovieDbDatasource(this.networkService);

  final NetworkService networkService;

  List<TvShow> _jsonToTvShows(Map<String, dynamic> json) {
    final TvMovieDbResponse tvDbResponse = TvMovieDbResponse.fromJson(json);

    final List<TvShow> tvShows = tvDbResponse.results
        .map((tvDb) => TvMapper.tvDBToEntity(tvDb))
        .where((tvDb) => tvDb.posterPath != 'no-poster')
        .toList();

    return tvShows;
  }

  @override
  Future<List<TvShow>> getAiringToday({int page = 1}) async {
    final response = await networkService.get(
      '/tv/airing_today',
      queryParameters: {'page': page},
    );

    return _jsonToTvShows(response.data);
  }

  @override
  Future<List<TvShow>> getOnTheAir({int page = 1}) async {
    final response = await networkService.get(
      '/tv/on_the_air',
      queryParameters: {'page': page},
    );

    return _jsonToTvShows(response.data);
  }

  @override
  Future<List<TvShow>> getPopular({int page = 1}) async {
    final response = await networkService.get(
      '/tv/popular',
      queryParameters: {'page': page},
    );

    return _jsonToTvShows(response.data);
  }

  @override
  Future<List<TvShow>> getTopRated({int page = 1}) async {
    final response = await networkService.get(
      '/tv/top_rated',
      queryParameters: {'page': page},
    );

    return _jsonToTvShows(response.data);
  }

  @override
  Future<TvShow> getSeriesById(String id) async {
    final response = await networkService.get('/tv/$id');

    if (response.statusCode != 200) {
      throw Exception('Series with id: $id not found');
    }

    final tvDetails = TvDetails.fromJson(response.data);

    return TvMapper.tvDetailsToEntity(tvDetails);
  }

  @override
  Future<List<Actor>> getCastBySeries(String seriesId) async {
    final response = await networkService.get('/tv/$seriesId/credits');

    final CreditsResponse creditsResponse = CreditsResponse.fromJson(
      response.data,
    );

    return creditsResponse.cast
        .map((actor) => ActorMapper.castToEntity(actor))
        .toList();
  }
}
