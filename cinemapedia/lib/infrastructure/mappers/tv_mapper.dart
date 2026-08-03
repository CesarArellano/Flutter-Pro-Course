import '../../domain/entities/tv_show.dart';
import '../models/moviedb/tv_details.dart';
import '../models/moviedb/tv_moviedb.dart';

class TvMapper {
  static TvShow tvDBToEntity(TvMovieDB tvDb) => TvShow(
    adult: tvDb.adult,
    backdropPath: (tvDb.backdropPath != '')
        ? 'https://image.tmdb.org/t/p/w500${tvDb.backdropPath}'
        : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
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
        : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
    genreIds: [...(tvDb.genres ?? []).map((genre) => genre.name ?? '')],
    id: tvDb.id,
    originalLanguage: tvDb.originalLanguage,
    originalName: tvDb.originalName,
    overview: tvDb.overview,
    popularity: tvDb.popularity,
    posterPath: (tvDb.posterPath != null && tvDb.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${tvDb.posterPath}'
        : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
    firstAirDate: tvDb.firstAirDate,
    name: tvDb.name,
    voteAverage: tvDb.voteAverage,
    voteCount: tvDb.voteCount,
    numberOfSeasons: tvDb.numberOfSeasons,
    numberOfEpisodes: tvDb.numberOfEpisodes,
    status: tvDb.status,
  );
}
