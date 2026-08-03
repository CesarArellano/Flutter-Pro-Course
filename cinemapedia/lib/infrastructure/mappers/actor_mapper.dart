import '../../config/constants/image_placeholders.dart';
import '../../domain/entities/actor.dart';
import '../models/moviedb/credits_reponse.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    character: cast.character,
    profilePath: cast.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
        : ImagePlaceholders.noProfileImage,
  );
}
