import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/tv_show.dart';
import 'series_providers.dart';

final seriesSlideshowProvider = Provider<List<TvShow>>((ref) {
  final airingTodaySeries = ref.watch(airingTodaySeriesProvider);

  if (airingTodaySeries.isEmpty) return [];

  return airingTodaySeries.sublist(0, 6);
});
