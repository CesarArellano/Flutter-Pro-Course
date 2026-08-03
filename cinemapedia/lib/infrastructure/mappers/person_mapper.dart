import '../../config/constants/image_placeholders.dart';
import '../../domain/entities/person.dart';
import '../models/moviedb/person_details.dart';
import '../models/moviedb/person_moviedb.dart';

class PersonMapper {
  static Person personDBToEntity(PersonMovieDB personDb) => Person(
    id: personDb.id,
    name: personDb.name,
    profilePath: personDb.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${personDb.profilePath}'
        : ImagePlaceholders.noProfileImage,
    popularity: personDb.popularity,
    knownForDepartment: personDb.knownForDepartment,
    gender: personDb.gender,
    adult: personDb.adult,
  );

  static Person personDetailsToEntity(PersonDetails personDetails) => Person(
    id: personDetails.id ?? 0,
    name: personDetails.name ?? '',
    profilePath: personDetails.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${personDetails.profilePath}'
        : ImagePlaceholders.noProfileImage,
    popularity: personDetails.popularity ?? 0.0,
    knownForDepartment: personDetails.knownForDepartment,
    gender: personDetails.gender,
    adult: personDetails.adult,
    biography: personDetails.biography,
    birthday: personDetails.birthday,
    deathday: personDetails.deathday,
    placeOfBirth: personDetails.placeOfBirth,
  );
}
