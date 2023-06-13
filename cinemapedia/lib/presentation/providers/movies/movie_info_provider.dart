
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/actors_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch( moviesRepositoryProvider );
  return MovieMapNotifier(
    getMovie: movieRepository.getMovieById
  );
});

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorRepository = ref.watch( actorsRepositoryProvider );
  return ActorsByMovieNotifier(
    getActors: actorRepository.getActorsByMovie
  );
});

typedef GetMovieCallback = Future<Movie> Function(String movieId);
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }): super({});

  Future<void> loadMovie(String movieId) async {
    if( state[movieId] != null ) return;
    
    final movie = await getMovie(movieId);

    state = {
      ...state,
      movieId: movie
    };
  }

}

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors,
  }): super({});

  Future<void> loadCast(String movieId) async {
    if( state[movieId] != null ) return;
    
    final actorList = await getActors(movieId);

    state = {
      ...state,
      movieId: actorList
    };
  }

}