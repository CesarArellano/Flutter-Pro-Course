import 'package:clappy/domain/entities/actor.dart';
import 'package:clappy/domain/entities/movie.dart';
import 'package:clappy/presentation/providers/movies/actors_repository_provider.dart';
import 'package:clappy/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
      final movieRepository = ref.watch(moviesRepositoryProvider);
      return MovieMapNotifier(getMovie: movieRepository.getMovieById);
    });

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((
      ref,
    ) {
      final actorRepository = ref.watch(actorsRepositoryProvider);
      return ActorsByMovieNotifier(getActors: actorRepository.getActorsByMovie);
    });

typedef GetMovieCallback = Future<Movie> Function(String movieId);
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  MovieMapNotifier({required this.getMovie}) : super({});
  final GetMovieCallback getMovie;

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final movie = await getMovie(movieId);
    if (!mounted) return;

    state = {...state, movieId: movie};
  }
}

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  ActorsByMovieNotifier({required this.getActors}) : super({});
  final GetActorsCallback getActors;

  Future<void> loadCast(String movieId) async {
    if (state[movieId] != null) return;

    final actorList = await getActors(movieId);
    if (!mounted) return;

    state = {...state, movieId: actorList};
  }
}
