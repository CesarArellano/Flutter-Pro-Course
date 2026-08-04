import 'package:clappy/domain/entities/actor.dart';
import 'package:clappy/presentation/providers/series/series_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final castBySeriesProvider =
    StateNotifierProvider<ActorsBySeriesNotifier, Map<String, List<Actor>>>((
      ref,
    ) {
      final seriesRepository = ref.watch(seriesRepositoryProvider);
      return ActorsBySeriesNotifier(getCast: seriesRepository.getCastBySeries);
    });

typedef GetSeriesCastCallback = Future<List<Actor>> Function(String seriesId);

class ActorsBySeriesNotifier extends StateNotifier<Map<String, List<Actor>>> {
  ActorsBySeriesNotifier({required this.getCast}) : super({});
  final GetSeriesCastCallback getCast;

  Future<void> loadCast(String seriesId) async {
    if (state[seriesId] != null) return;

    final cast = await getCast(seriesId);
    if (!mounted) return;

    state = {...state, seriesId: cast};
  }
}
