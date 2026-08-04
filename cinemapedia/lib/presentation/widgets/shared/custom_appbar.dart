import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';
import '../../../l10n/app_localizations.dart';
import '../../delegates/search_movie_delegate.dart';
import '../../providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: colors.surface.withValues(alpha: 0.7),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  Icon(Icons.movie_outlined, color: colors.primary),
                  const SizedBox(width: 5),
                  Text('Clappy', style: titleStyle),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      final searchedMovies = ref.read(searchedMoviesProvider);
                      final searchQuery = ref.read(searchQueryProvider);

                      showSearch<Movie?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchMovieDelegate(
                          initialMovies: searchedMovies,
                          searchFieldHint: AppLocalizations.of(
                            context,
                          )!.searchFieldHint,
                          searchMovies: ref
                              .read(searchedMoviesProvider.notifier)
                              .searchMoviesByQuery,
                        ),
                      ).then((movie) {
                        if (movie == null || !context.mounted) return;
                        context.push('/home/0/movie/${movie.id}');
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.preferencesTooltip,
                    onPressed: () => context.push('/home/0/preferences'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
