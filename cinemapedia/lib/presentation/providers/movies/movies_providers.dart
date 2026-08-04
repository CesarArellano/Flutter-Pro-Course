import 'package:clappy/domain/entities/movie.dart';
import 'package:clappy/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Each provider calls loadNextPage() immediately on creation rather than
// relying solely on HomeView.initState() (which only ever fires once). Since
// these providers watch moviesRepositoryProvider — which rebuilds whenever
// the language preference changes — Riverpod recreates the notifier (with
// empty state) on every language switch; without this, nothing would ever
// repopulate it. loadNextPage()'s own `isLoading` guard makes this safe to
// call again redundantly from HomeView.initState() too.
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(moviesRepositoryProvider).getNowPlaying;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies)..loadNextPage();
    });

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final getUpcomingMovies = ref.watch(moviesRepositoryProvider).getUpcoming;

      return MoviesNotifier(fetchMoreMovies: getUpcomingMovies)..loadNextPage();
    });

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final getTopRatedMovies = ref.watch(moviesRepositoryProvider).getTopRated;

      return MoviesNotifier(fetchMoreMovies: getTopRatedMovies)..loadNextPage();
    });

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final getPopularMovies = ref.watch(moviesRepositoryProvider).getPopular;

      return MoviesNotifier(fetchMoreMovies: getPopularMovies)..loadNextPage();
    });

// Definition of usecase
typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    if (!mounted) return;
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
