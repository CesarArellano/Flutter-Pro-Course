import 'package:clappy/domain/entities/tv_show.dart';
import 'package:clappy/presentation/providers/series/series_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final seriesInfoProvider =
    StateNotifierProvider<SeriesMapNotifier, Map<String, TvShow>>((ref) {
      final seriesRepository = ref.watch(seriesRepositoryProvider);
      return SeriesMapNotifier(getSeries: seriesRepository.getSeriesById);
    });

typedef GetSeriesCallback = Future<TvShow> Function(String seriesId);

class SeriesMapNotifier extends StateNotifier<Map<String, TvShow>> {
  SeriesMapNotifier({required this.getSeries}) : super({});
  final GetSeriesCallback getSeries;

  Future<void> loadSeries(String seriesId) async {
    if (state[seriesId] != null) return;

    final series = await getSeries(seriesId);
    if (!mounted) return;

    state = {...state, seriesId: series};
  }
}
