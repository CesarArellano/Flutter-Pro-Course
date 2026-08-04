import 'package:clappy/domain/entities/tv_show.dart';
import 'package:clappy/presentation/providers/series/series_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final airingTodaySeriesProvider =
    StateNotifierProvider<SeriesNotifier, List<TvShow>>((ref) {
      final fetchMoreSeries = ref
          .watch(seriesRepositoryProvider)
          .getAiringToday;

      return SeriesNotifier(fetchMoreSeries: fetchMoreSeries);
    });

final onTheAirSeriesProvider =
    StateNotifierProvider<SeriesNotifier, List<TvShow>>((ref) {
      final fetchMoreSeries = ref.watch(seriesRepositoryProvider).getOnTheAir;

      return SeriesNotifier(fetchMoreSeries: fetchMoreSeries);
    });

final popularSeriesProvider =
    StateNotifierProvider<SeriesNotifier, List<TvShow>>((ref) {
      final fetchMoreSeries = ref.watch(seriesRepositoryProvider).getPopular;

      return SeriesNotifier(fetchMoreSeries: fetchMoreSeries);
    });

final topRatedSeriesProvider =
    StateNotifierProvider<SeriesNotifier, List<TvShow>>((ref) {
      final fetchMoreSeries = ref.watch(seriesRepositoryProvider).getTopRated;

      return SeriesNotifier(fetchMoreSeries: fetchMoreSeries);
    });

// Definition of usecase
typedef SeriesCallback = Future<List<TvShow>> Function({int page});

class SeriesNotifier extends StateNotifier<List<TvShow>> {
  SeriesNotifier({required this.fetchMoreSeries}) : super([]);

  int currentPage = 0;
  bool isLoading = false;
  SeriesCallback fetchMoreSeries;

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;

    final List<TvShow> series = await fetchMoreSeries(page: currentPage);
    if (!mounted) return;
    state = [...state, ...series];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
