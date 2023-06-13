import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../config/extensions/null_extensions.dart';
import '../../domain/entities/movie.dart';
import '../widgets/widgets.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);
class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController<List<Movie>>.broadcast();
  StreamController<bool> isLoadingStream = StreamController<bool>.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    this.initialMovies = const []
  }):super(
    searchFieldLabel: 'Search movie'
  );

  Widget _buildSuggestionsAndResults() {
    if( query.isEmpty ) {
      return const EmptyContainer();
    }
    
    return StreamBuilder<List<Movie>>(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: ( _, AsyncSnapshot<List<Movie>> asyncSnapshot) {
        if( !asyncSnapshot.hasData) {
          return const EmptyContainer();
        }
        final movies = asyncSnapshot.data ?? [];

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, int i) => _MovieItem( 
            movie: movies[i],
            onMovieSelected: (Movie? movie) {
              close(context, movie);
              clearStreams();
            },
          )
        );
      }
    );

  }

  void clearStreams() {
    debouncedMovies.close();
    isLoadingStream.close();
  }

  void onQueryChanged(String query) {
    isLoadingStream.add(true);
    if( (_debounceTimer?.isActive).value() ) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder<bool>(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if( snapshot.data.value() ) {
            return SpinPerfect(
              spins: 10,
              infinite: true,
              duration: const Duration(seconds: 20),
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon(Icons.refresh_rounded),
                splashRadius: 22,
              ),
            );
          }
          
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon(Icons.clear),
              splashRadius: 22,
            ),
          );

        }
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        clearStreams();
      }, 
      icon: const Icon( Icons.arrow_back ),
      splashRadius: 22,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);
    return _buildSuggestionsAndResults();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestionsAndResults();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function(Movie? movie) onMovieSelected;

  const _MovieItem({
    Key? key,
    required this.movie,
    required this.onMovieSelected,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    const TextStyle chipTextStyle = TextStyle(fontWeight: FontWeight.bold);
    
    movie.heroId = 'search-movie-${ movie.title }-${ movie.id }';

    return InkWell(
      onTap: () => onMovieSelected(movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Hero(
              tag: movie.heroId!,
              child: SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/loading.gif'), 
                    image: NetworkImage( movie.posterPath.value() ),
                    width: 80,
                    fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.value(),
                    style: textStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    movie.overview.value(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        HumanFormats.number(movie.voteAverage.value(), 2),
                        style: chipTextStyle
                      ),
                    ]
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}