import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/tv_show.dart';
import '../widgets.dart';

class SeriesMasonry extends StatefulWidget {
  const SeriesMasonry({
    super.key,
    required this.series,
    required this.loadNextPage,
    this.topPadding = 0,
  });
  final List<TvShow> series;
  final VoidCallback loadNextPage;

  /// Extra top inset so the first row starts below an overlaid translucent
  /// app bar — see [MovieMasonry.topPadding] for why this lives in the
  /// scrollable's own padding rather than an outer widget.
  final double topPadding;

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
  void didUpdateWidget(covariant SeriesMasonry oldWidget) {
    super.didUpdateWidget(oldWidget);
    // See SeriesHorizontalListview.didUpdateWidget for why this is needed:
    // initState() won't rerun when Flutter reuses this State across
    // rebuilds, so a language-triggered provider reset (list back to empty)
    // would otherwise never re-trigger the lazy-load bootstrap.
    if (widget.series.isEmpty) widget.loadNextPage();
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

    return MasonryGridView.count(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(10, widget.topPadding, 10, 10),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: widget.series.length,
      itemBuilder: (context, index) {
        final seriesPosterLink = SeriesPosterLink(series: widget.series[index]);

        if (index == 1) {
          return Column(
            children: [const SizedBox(height: 40), seriesPosterLink],
          );
        }

        return seriesPosterLink;
      },
    );
  }
}
