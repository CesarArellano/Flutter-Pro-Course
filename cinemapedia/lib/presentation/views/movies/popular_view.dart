import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final contentType = ref.watch(contentTypeProvider);

    return switch (contentType) {
      ContentType.movies => const _PopularMovies(topPadding: 0),
      ContentType.series => const _PopularSeries(topPadding: 0),
    };
  }

  @override
  bool get wantKeepAlive => true;
}

class _PopularMovies extends ConsumerWidget {
  const _PopularMovies({required this.topPadding});
  final double topPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMovies = ref.watch(popularMoviesProvider);

    if (popularMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return MovieMasonry(
      loadNextPage: () =>
          ref.read(popularMoviesProvider.notifier).loadNextPage(),
      movies: popularMovies,
      topPadding: topPadding,
    );
  }
}

class _PopularSeries extends ConsumerWidget {
  const _PopularSeries({required this.topPadding});
  final double topPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularSeries = ref.watch(popularSeriesProvider);

    // No emptiness guard here (unlike _PopularMovies): SeriesMasonry itself
    // must always mount so its initState can lazy-load the list — gating on
    // isEmpty at this level would return a bare loader forever, since
    // SeriesMasonry (and its self-bootstrap) would never get built.
    return SeriesMasonry(
      loadNextPage: () =>
          ref.read(popularSeriesProvider.notifier).loadNextPage(),
      series: popularSeries,
      topPadding: topPadding,
    );
  }
}
