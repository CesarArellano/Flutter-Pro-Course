import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_edge_blur/fog_edge_blur.dart';
import 'package:fog_edge_blur/fog_edge_child.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/extensions/null_extensions.dart';
import '../../../domain/entities/actor.dart';
import '../../../domain/entities/movie.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/movies/movie_info_provider.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key, required this.movieId});

  static const name = 'movie-screen';

  final String movieId;

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    unawaited(ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId));
    unawaited(
      ref.read(actorsByMovieProvider.notifier).loadCast(widget.movieId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // No CustomAppbar here — this screen already has its own hero-image
      // sliver header. Just the top-edge blur treatment, sized to match the
      // same status-bar-plus-toolbar band CustomAppbar uses elsewhere.
      body: FogEdgeBlur(
        edgeAlign: EdgeAlign.top,
        sigma: 20,
        fogEdgeChild: FogEdgeChild(heightEdge: kToolbarHeight - 10),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            _CustomSliverAppbar(movie: movie),
            SliverToBoxAdapter(child: _MovieDetails(movie: movie)),
          ],
        ),
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((
  ref,
  int movieId,
) {
  final localStorageProvider = ref.watch(localStorageRepositoryProvider);
  return localStorageProvider.isMovieFavorite(movieId);
});

class _CustomSliverAppbar extends ConsumerWidget {
  const _CustomSliverAppbar({required this.movie});

  final Movie movie;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id.value()));

    return SliverAppBar(
      foregroundColor: Colors.white,
      expandedHeight: size.height * 0.7,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: AppNetworkImage(
                imageUrl: movie.posterPath.value(),
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
      actions: [
        IconButton(
          onPressed: () async {
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id.value()));
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border),
            error: (error, stackTrace) => const Icon(Icons.favorite_border),
            loading: () => const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieDetails extends StatelessWidget {
  const _MovieDetails({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderDetails(movie: movie),
        _Overview(movie: movie),
        _MoreDetails(movie: movie),
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 8),
        VideosFromMovie(movieId: movie.id.value()),
        const SizedBox(height: 4),
        SimilarMovies(movieId: movie.id.value()),
        const SizedBox(height: 12),
      ],
    );
  }
}

class HeaderDetails extends StatelessWidget {
  const HeaderDetails({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    const TextStyle chipTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AppNetworkImage(
              imageUrl: movie.posterPath.value(),
              width: size.width * 0.3,
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title ?? l10n.noTitle,
                  style: textStyles.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  movie.originalTitle.value(),
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
                            ).format(movie.voteAverage),
                            style: chipTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (movie.adult.value())
                      Chip(
                        backgroundColor: Colors.red,
                        label: Text(l10n.adultTag, style: chipTextStyle),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.overview,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(movie.overview.value(), textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}

class _MoreDetails extends StatelessWidget {
  const _MoreDetails({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final numberFormater = NumberFormat("\$#,##0.00 USD", "en_US");

    final releaseDate = movie.releaseDate ?? DateTime.now();
    final budget = numberFormater.format(movie.budget ?? 0);
    final revenue = numberFormater.format(movie.revenue ?? 0);
    final genreIds = movie.genreIds ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            l10n.details,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            label: l10n.releaseDate,
            value:
                '${releaseDate.day}-${releaseDate.month}-${releaseDate.year}',
          ),
          _DetailRow(
            icon: Icons.timer_outlined,
            label: l10n.duration,
            value: '${durationToString(movie.runtime ?? 0)}h',
          ),
          _DetailRow(
            icon: Icons.attach_money,
            label: l10n.budget,
            value: budget,
          ),
          _DetailRow(
            icon: Icons.trending_up,
            label: l10n.revenue,
            value: revenue,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String durationToString(int minutes) {
    final d = Duration(minutes: minutes);
    final List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
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

class _ActorsByMovie extends ConsumerWidget {
  const _ActorsByMovie({required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actors = ref.watch(actorsByMovieProvider)[movieId] ?? [];

    if (actors.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) => _CastCard(actor: actors[index]),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.actor});
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isDarkTheme ? Colors.black38 : Colors.white,
      elevation: 6,
      child: InkWell(
        onTap: () => context.push('/home/0/person/${actor.id}'),
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
                actor.character.value(l10n.noCharacter),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      )
    );
  }
}
