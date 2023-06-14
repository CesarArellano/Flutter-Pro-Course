import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/extensions/null_extensions.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/repositories/local_storage_repository.dart';
import '../providers.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageMovieNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMovieNotifier(localStorageRepository: localStorageRepository);
});

class StorageMovieNotifier extends StateNotifier<Map<int,Movie>> {
  int page = 0;

  final LocalStorageRepository localStorageRepository;

  StorageMovieNotifier({
    required this.localStorageRepository
  }): super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10);
    page++;
    
    final tempMoviesMap = <int,Movie>{};
    
    for (Movie movie in movies) {
      tempMoviesMap[movie.id.value()] = movie;
    }

    state = {
      ...state,
      ...tempMoviesMap,
    };

    return movies;
  }

  Future<void> toggleFavorite( Movie movie ) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if( isMovieInFavorites ) {
      final newState = { ...state };
      newState.remove(movie.id);
      state = newState;
    } else {
      state = { ...state, movie.id.value(): movie };
    }
  }
}