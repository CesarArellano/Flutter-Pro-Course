import 'package:clappy/domain/datasources/actors_datasource.dart';
import 'package:clappy/domain/entities/actor.dart';
import 'package:clappy/infrastructure/mappers/actor_mapper.dart';
import 'package:clappy/infrastructure/models/moviedb/credits_reponse.dart';

import '../../config/network/network_service.dart';

class ActorMovieDbDatasource implements ActorsDatasource {
  ActorMovieDbDatasource(this.networkService);

  final NetworkService networkService;

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await networkService.get('/movie/$movieId/credits');

    final CreditsResponse creditsReponse = CreditsResponse.fromJson(
      response.data,
    );

    final List<Actor> actorList = creditsReponse.cast
        .map((actor) => ActorMapper.castToEntity(actor))
        .toList();

    return actorList;
  }
}
