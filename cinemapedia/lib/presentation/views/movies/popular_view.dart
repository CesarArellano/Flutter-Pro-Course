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

    return Scaffold(
      body: Column(
        children: [
          const CustomAppbar(),
          Expanded(
            child: switch (contentType) {
              ContentType.movies => _PopularMovies(),
              ContentType.series => _PopularSeries(),
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PopularMovies extends ConsumerWidget {
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
    );
  }
}

class _PopularSeries extends ConsumerWidget {
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
    );
  }
}
