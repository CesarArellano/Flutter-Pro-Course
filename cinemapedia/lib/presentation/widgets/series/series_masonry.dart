import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/tv_show.dart';
import '../widgets.dart';

class SeriesMasonry extends StatefulWidget {
  const SeriesMasonry({
    super.key,
    required this.series,
    required this.loadNextPage,
  });
  final List<TvShow> series;
  final VoidCallback loadNextPage;

  @override
  State<SeriesMasonry> createState() => _SeriesMasonryState();
}

class _SeriesMasonryState extends State<SeriesMasonry> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // See SeriesHorizontalListview for why this self-bootstraps: Series
    // lists are lazy-loaded, unlike Movies, which are preloaded elsewhere.
    if (widget.series.isEmpty) widget.loadNextPage();

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
    if (widget.series.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.series.length,
        itemBuilder: (context, index) {
          final seriesPosterLink = SeriesPosterLink(
            series: widget.series[index],
          );

          if (index == 1) {
            return Column(
              children: [const SizedBox(height: 40), seriesPosterLink],
            );
          }

          return seriesPosterLink;
        },
      ),
    );
  }
}
