import '../../config/constants/image_placeholders.dart';
import '../../domain/entities/movie_credit.dart';
import '../models/moviedb/person_movie_credits_response.dart';

class MovieCreditMapper {
  static MovieCredit castToEntity(PersonCastMovie cast) => MovieCredit(
    id: cast.id,
    title: cast.title,
    posterPath: (cast.posterPath != null && cast.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${cast.posterPath}'
        : ImagePlaceholders.posterNotFound,
    voteAverage: cast.voteAverage,
    character: cast.character,
    releaseDate: cast.releaseDate,
  );
}
