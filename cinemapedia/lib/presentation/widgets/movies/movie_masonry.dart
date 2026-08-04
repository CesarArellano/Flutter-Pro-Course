import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/movie.dart';
import '../widgets.dart';

class MovieMasonry extends StatefulWidget {
  const MovieMasonry({
    super.key,
    required this.movies,
    required this.loadNextPage,
    this.topPadding = 0,
  });
  final List<Movie> movies;
  final VoidCallback loadNextPage;

  /// Extra top inset so the first row starts below an overlaid translucent
  /// app bar (see [CustomAppbar]) instead of the grid's own [padding] living
  /// outside the scrollable — that would just shrink the viewport rather
  /// than letting content scroll underneath the bar.
  final double topPadding;

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      final position = _scrollController.position;

      if (position.pixels + 100 >= position.maxScrollExtent) {
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
    return MasonryGridView.count(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(10, widget.topPadding, 10, 10),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        final moviePosterLink = MoviePosterLink(movie: widget.movies[index]);

        if (index == 1) {
          return Column(
            children: [const SizedBox(height: 40), moviePosterLink],
          );
        }

        return moviePosterLink;
      },
    );
  }
}
