import 'package:clappy/domain/entities/actor.dart';
import 'package:clappy/domain/repositories/actors_repository.dart';
import 'package:clappy/infrastructure/datasources/actor_moviedb_datasource.dart';

class ActorsRepositoryImpl implements ActorsRepository {
  ActorsRepositoryImpl(this.datasource);

  final ActorMovieDbDatasource datasource;

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
