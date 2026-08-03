import '../../domain/entities/person.dart';
import '../models/moviedb/person_details.dart';
import '../models/moviedb/person_moviedb.dart';

class PersonMapper {
  static Person personDBToEntity(PersonMovieDB personDb) => Person(
    id: personDb.id,
    name: personDb.name,
    profilePath: personDb.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${personDb.profilePath}'
        : 'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png?fit=500%2C500&ssl=1',
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
        : 'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png?fit=500%2C500&ssl=1',
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
