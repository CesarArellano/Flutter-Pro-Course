import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_reponse.dart';
import 'package:dio/dio.dart';

import '../../config/constants/environment.dart';

class ActorMovieDbDatasource implements ActorsDatasource {
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX',
    }
  ));
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async { 
    final response = await dio.get('/movie/$movieId/credits');

    final CreditsResponse creditsReponse = CreditsResponse.fromJson(response.data);

    final List<Actor> actorList = creditsReponse.cast.map(
      (actor) => ActorMapper.castToEntity(actor)
    ).toList();

    return actorList;
  }

}