import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/movie.dart';
import '../widgets.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback loadNextPage;
  
  const MovieMasonry({
    super.key,
    required this.movies,
    required this.loadNextPage
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      final position = _scrollController.position;
      
      if( position.pixels + 100 >= position.maxScrollExtent ) {
        widget.loadNextPage();
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder:(context, index) {
          final moviePosterLink = MoviePosterLink(
            movie: widget.movies[index]
          );

          if( index == 1 ) {
            return Column(
              children: [
                const SizedBox(height: 40,),
                moviePosterLink
              ],
            );
          }

          return moviePosterLink;
        },
      ),
    );
  }
}