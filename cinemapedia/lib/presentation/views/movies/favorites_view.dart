import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  
  const FavoritesView({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive => true;

  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage(); 
  }

  void loadNextPage() async {
    if( isLoading || isLastPage ) return;
    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if( movies.isEmpty ) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;

    if( favoriteMovies.isEmpty ) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_outlined, size: 60, color: colors.primary),
            Text('Ohh no!!', style: TextStyle(fontSize: 30, color: colors.primary)),
            const Text(
              "You don't have favorite movies",
              style: TextStyle(fontSize: 20)
            ),
            const SizedBox(height: 20,),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'),
              child: const Text('Start searching')
            )
          ],
        )
      );
    }

    return MovieMasonry(
      movies: favoriteMovies,
      loadNextPage: loadNextPage
    );
  }
}