import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';

  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  ConsumerState<_HomeView> createState() => __HomeViewState();
}

class __HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch( initialLoadingProvider );

    if(initialLoading ) {
      return const FullScreenLoader();
    }

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final slideshowMovies = ref.watch( moviesSlideshowProvider );    

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            title: CustomAppbar()
          ),
        ),
        SliverList(delegate: SliverChildListDelegate.fixed([
          MoviesSlideshow(movies: slideshowMovies),
          MovieHorizontalListview(
            title: 'In Theaters',
            subtitle: 'Monday 12',
            movies: nowPlayingMovies,
            loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
          ),
          MovieHorizontalListview(
            title: 'Upcoming',
            movies: upcomingMovies,
            loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
          ),
          MovieHorizontalListview(
            title: 'Popular',
            movies: popularMovies,
            loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
          ),
          MovieHorizontalListview(
            title: 'Top Rated',
            subtitle: 'Since ever',
            movies: topRatedMovies,
            loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
          ),
          const SizedBox(height: 10),
        ]))
      ],
    );
  }
}