import '../../domain/entities/movie_credit.dart';
import '../models/moviedb/person_movie_credits_response.dart';

class MovieCreditMapper {
  static MovieCredit castToEntity(PersonCastMovie cast) => MovieCredit(
    id: cast.id,
    title: cast.title,
    posterPath: (cast.posterPath != null && cast.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${cast.posterPath}'
        : 'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
    voteAverage: cast.voteAverage,
    character: cast.character,
    releaseDate: cast.releaseDate,
  );
}
