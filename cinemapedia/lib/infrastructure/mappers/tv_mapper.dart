import '../../config/constants/image_placeholders.dart';
import '../../domain/entities/tv_season.dart';
import '../../domain/entities/tv_show.dart';
import '../models/moviedb/tv_details.dart';
import '../models/moviedb/tv_moviedb.dart';

class TvMapper {
  static TvShow tvDBToEntity(TvMovieDB tvDb) => TvShow(
    adult: tvDb.adult,
    backdropPath: (tvDb.backdropPath != '')
        ? 'https://image.tmdb.org/t/p/w500${tvDb.backdropPath}'
        : ImagePlaceholders.posterNotFound,
    genreIds: [...tvDb.genreIds.map((genreId) => genreId.toString())],
    id: tvDb.id,
    originalLanguage: tvDb.originalLanguage,
    originalName: tvDb.originalName,
    overview: tvDb.overview,
    popularity: tvDb.popularity,
    posterPath: (tvDb.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${tvDb.posterPath}'
        : 'no-poster',
    firstAirDate: tvDb.firstAirDate,
    name: tvDb.name,
    voteAverage: tvDb.voteAverage,
    voteCount: tvDb.voteCount,
    numberOfSeasons: 0,
    numberOfEpisodes: 0,
    status: null,
  );

  static TvShow tvDetailsToEntity(TvDetails tvDb) => TvShow(
    adult: tvDb.adult,
    backdropPath: (tvDb.backdropPath != '')
        ? 'https://image.tmdb.org/t/p/w500${tvDb.backdropPath}'
        : ImagePlaceholders.posterNotFound,
    genreIds: [...(tvDb.genres ?? []).map((genre) => genre.name ?? '')],
    id: tvDb.id,
    originalLanguage: tvDb.originalLanguage,
    originalName: tvDb.originalName,
    overview: tvDb.overview,
    popularity: tvDb.popularity,
    posterPath: (tvDb.posterPath != null && tvDb.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${tvDb.posterPath}'
        : ImagePlaceholders.posterNotFound,
    firstAirDate: tvDb.firstAirDate,
    name: tvDb.name,
    voteAverage: tvDb.voteAverage,
    voteCount: tvDb.voteCount,
    numberOfSeasons: tvDb.numberOfSeasons,
    numberOfEpisodes: tvDb.numberOfEpisodes,
    status: tvDb.status,
    lastSeason: _lastSeasonFrom(tvDb.seasons),
  );

  // TMDB lists seasons in ascending order; the last "real" season (excluding
  // specials, season_number 0) is the most recently released one.
  static TvSeason? _lastSeasonFrom(List<Season>? seasons) {
    if (seasons == null || seasons.isEmpty) return null;

    final realSeasons = seasons.where((s) => (s.seasonNumber ?? 0) > 0);
    final latest = realSeasons.isNotEmpty ? realSeasons.last : seasons.last;

    return TvSeason(
      seasonNumber: latest.seasonNumber,
      name: latest.name,
      posterPath: (latest.posterPath != null && latest.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${latest.posterPath}'
          : ImagePlaceholders.posterNotFound,
      airDate: latest.airDate,
      episodeCount: latest.episodeCount,
      voteAverage: latest.voteAverage,
      overview: latest.overview,
    );
  }
}
