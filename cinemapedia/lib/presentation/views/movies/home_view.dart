import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    unawaited(ref.read(nowPlayingMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(upcomingMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(popularMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(topRatedMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(popularPeopleProvider.notifier).loadNextPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) {
      return const FullScreenLoader();
    }

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final contentType = ref.watch(contentTypeProvider);
    final airingTodaySeries = ref.watch(airingTodaySeriesProvider);
    final onTheAirSeries = ref.watch(onTheAirSeriesProvider);
    final popularSeries = ref.watch(popularSeriesProvider);
    final topRatedSeries = ref.watch(topRatedSeriesProvider);

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: ContentType.values
                    .map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(type.label(context)),
                          selected: contentType == type,
                          onSelected: (_) =>
                              ref.read(contentTypeProvider.notifier).state =
                                  type,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const ContentSlideshow(),
            ...switch (contentType) {
              ContentType.movies => [
                MovieHorizontalListview(
                  title: l10n.inTheaters,
                  subtitle: l10n.mondaySubtitle,
                  movies: nowPlayingMovies,
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                MovieHorizontalListview(
                  title: l10n.upcoming,
                  movies: upcomingMovies,
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  title: l10n.popular,
                  movies: popularMovies,
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  title: l10n.topRated,
                  subtitle: l10n.sinceEverSubtitle,
                  movies: topRatedMovies,
                  loadNextPage: () =>
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),
              ],
              ContentType.series => [
                SeriesHorizontalListview(
                  title: l10n.airingToday,
                  series: airingTodaySeries,
                  loadNextPage: () => ref
                      .read(airingTodaySeriesProvider.notifier)
                      .loadNextPage(),
                ),
                SeriesHorizontalListview(
                  title: l10n.onTheAir,
                  series: onTheAirSeries,
                  loadNextPage: () =>
                      ref.read(onTheAirSeriesProvider.notifier).loadNextPage(),
                ),
                SeriesHorizontalListview(
                  title: l10n.popular,
                  series: popularSeries,
                  loadNextPage: () =>
                      ref.read(popularSeriesProvider.notifier).loadNextPage(),
                ),
                SeriesHorizontalListview(
                  title: l10n.topRated,
                  series: topRatedSeries,
                  loadNextPage: () =>
                      ref.read(topRatedSeriesProvider.notifier).loadNextPage(),
                ),
              ],
            },
            const SizedBox(height: 10),
          ]),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
