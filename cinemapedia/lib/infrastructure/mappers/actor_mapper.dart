import '../../domain/entities/actor.dart';
import '../models/moviedb/credits_reponse.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    character: cast.character,
    profilePath: cast.profilePath != null
      ? 'https://image.tmdb.org/t/p/w500${ cast.profilePath }'
      : 'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png?fit=500%2C500&ssl=1'
  );
}