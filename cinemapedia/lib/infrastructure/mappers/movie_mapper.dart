import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB movieDb) => Movie(
    adult: movieDb.adult,
    backdropPath: (movieDb.backdropPath != '' )
      ? 'https://image.tmdb.org/t/p/w500${ movieDb.backdropPath }'
      : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
    genreIds:  [ ...movieDb.genreIds.map((genreId) => genreId.toString()) ],
    id: movieDb.id,
    originalLanguage: movieDb.originalLanguage,
    originalTitle: movieDb.originalTitle, 
    overview: movieDb.overview,
    popularity: movieDb.popularity,
    posterPath: (movieDb.posterPath != '' )
      ? 'https://image.tmdb.org/t/p/w500${ movieDb.posterPath }'
      : 'no-poster',
    releaseDate: movieDb.releaseDate,
    title: movieDb.title,
    video: movieDb.video,
    voteAverage: movieDb.voteAverage,
    voteCount: movieDb.voteCount
  );

  static Movie movieDetailsToEntity(MovieDetails movieDb) => Movie(
    adult: movieDb.adult,
    backdropPath: (movieDb.backdropPath != '' )
      ? 'https://image.tmdb.org/t/p/w500${ movieDb.backdropPath }'
      : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
    genreIds:  [ ...(movieDb.genres ?? []).map((genre) => genre.name ?? '') ],
    id: movieDb.id,
    originalLanguage: movieDb.originalLanguage,
    originalTitle: movieDb.originalTitle, 
    overview: movieDb.overview,
    popularity: movieDb.popularity,
    posterPath: (movieDb.posterPath != '' )
      ? 'https://image.tmdb.org/t/p/w500${ movieDb.posterPath }'
      : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
    releaseDate: movieDb.releaseDate,
    title: movieDb.title,
    video: movieDb.video,
    voteAverage: movieDb.voteAverage,
    voteCount: movieDb.voteCount
  );
}