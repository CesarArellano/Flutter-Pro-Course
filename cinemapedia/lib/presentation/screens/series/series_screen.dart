import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/extensions/null_extensions.dart';
import '../../../domain/entities/actor.dart';
import '../../../domain/entities/tv_season.dart';
import '../../../domain/entities/tv_show.dart';
import '../../providers/series/series_cast_provider.dart';
import '../../providers/series/series_info_provider.dart';
import '../../widgets/shared/app_network_image.dart';

class SeriesScreen extends ConsumerStatefulWidget {
  const SeriesScreen({super.key, required this.seriesId});

  static const name = 'series-screen';

  final String seriesId;

  @override
  ConsumerState<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends ConsumerState<SeriesScreen> {
  @override
  void initState() {
    unawaited(
      ref.read(seriesInfoProvider.notifier).loadSeries(widget.seriesId),
    );
    unawaited(
      ref.read(castBySeriesProvider.notifier).loadCast(widget.seriesId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TvShow? series = ref.watch(seriesInfoProvider)[widget.seriesId];

    if (series == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(series: series),
          SliverToBoxAdapter(child: _SeriesDetails(series: series)),
        ],
      ),
    );
  }
}

class _CustomSliverAppbar extends StatelessWidget {
  const _CustomSliverAppbar({required this.series});

  final TvShow series;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      foregroundColor: Colors.white,
      expandedHeight: size.height * 0.7,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: AppNetworkImage(
                imageUrl: series.backdropPath.value(),
                width: size.width,
                height: size.height * 0.7,
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.0, 0.2],
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.3],
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeriesDetails extends StatelessWidget {
  const _SeriesDetails({required this.series});

  final TvShow series;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    const TextStyle chipTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AppNetworkImage(
                  imageUrl: series.posterPath.value(),
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      series.name ?? 'No title',
                      style: textStyles.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      series.originalName.value(),
                      style: textStyles.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          backgroundColor: Colors.black,
                          label: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow),
                              const SizedBox(width: 5),
                              Text(
                                NumberFormat.decimalPatternDigits(
                                  decimalDigits: 2,
                                ).format(series.voteAverage),
                                style: chipTextStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (series.adult.value())
                          const Chip(
                            backgroundColor: Colors.red,
                            label: Text('+18', style: chipTextStyle),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _Overview(series: series),
        _MoreDetails(series: series),
        _SeriesCast(seriesId: series.id.toString()),
        if (series.lastSeason != null) _LastSeason(season: series.lastSeason!),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.series});
  final TvShow series;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(series.overview.value(), textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}

class _MoreDetails extends StatelessWidget {
  const _MoreDetails({required this.series});

  final TvShow series;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final firstAirDate = series.firstAirDate;
    final genreIds = series.genreIds ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (genreIds.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: genreIds
                  .map(
                    (genre) => Chip(
                      label: Text(genre),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: colors.secondaryContainer,
                    ),
                  )
                  .toList(),
            ),
          if (genreIds.isNotEmpty) const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'First air date',
            value: firstAirDate != null
                ? '${firstAirDate.day}-${firstAirDate.month}-${firstAirDate.year}'
                : 'Unknown',
          ),
          _DetailRow(
            icon: Icons.video_library_outlined,
            label: 'Seasons',
            value: '${series.numberOfSeasons.value()}',
          ),
          _DetailRow(
            icon: Icons.movie_filter_outlined,
            label: 'Episodes',
            value: '${series.numberOfEpisodes.value()}',
          ),
          _DetailRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: series.status.valueEmpty('Unknown'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeriesCast extends ConsumerWidget {
  const _SeriesCast({required this.seriesId});

  final String seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cast = ref.watch(castBySeriesProvider)[seriesId] ?? [];

    if (cast.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Cast',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) => _CastCard(actor: cast[index]),
          ),
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.actor});
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.push('/home/0/person/${actor.id}'),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkTheme ? Colors.black38 : Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(blurRadius: 6, color: Colors.black12),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AppNetworkImage(
                imageUrl: actor.profilePath,
                width: double.infinity,
                height: 170,
                cacheWidth: 150,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                actor.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                actor.character.value('No-character'),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastSeason extends StatelessWidget {
  const _LastSeason({required this.season});
  final TvSeason season;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final airDate = season.airDate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Last Season',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppNetworkImage(
                  imageUrl: season.posterPath.value(),
                  width: 100,
                  height: 150,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.name.value('Season'),
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          backgroundColor: Colors.black,
                          visualDensity: VisualDensity.compact,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow.shade700,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                NumberFormat.decimalPatternDigits(
                                  decimalDigits: 1,
                                ).format(season.voteAverage.value()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (airDate != null)
                          Text('${airDate.year}', style: textTheme.bodyMedium),
                        const SizedBox(width: 8),
                        Text(
                          '${season.episodeCount.value()} episodes',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      season.overview.valueEmpty('No overview available.'),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
