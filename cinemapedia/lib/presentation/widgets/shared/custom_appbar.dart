import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.movie_outlined, color: colors.primary),
            const SizedBox(width: 5),
            Text('Cinemapedia', style: titleStyle,),
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
                    searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery
                )
                ).then((movie) {
                  if( movie == null ) return;
                  context.push('/movie/${ movie.id }');
                });
              },
              icon: const Icon(Icons.search)
            )
          ],
        ),
      ),
    );
  }
}