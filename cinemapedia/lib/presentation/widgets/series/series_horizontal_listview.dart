import 'package:animate_do/animate_do.dart';
import 'package:clappy/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/tv_show.dart';
import '../shared/app_network_image.dart';

class SeriesHorizontalListview extends StatefulWidget {
  const SeriesHorizontalListview({
    super.key,
    required this.series,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });
  final List<TvShow> series;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  @override
  State<SeriesHorizontalListview> createState() =>
      _SeriesHorizontalListviewState();
}

class _SeriesHorizontalListviewState extends State<SeriesHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    // Unlike MovieHorizontalListview, Series lists are lazy-loaded (nothing is
    // preloaded in HomeView.initState), so this widget bootstraps its own
    // provider the first time it's shown. Safe against remounts: the list
    // lives in Riverpod state, not local widget state, so a later remount
    // sees it already populated and no-ops here.
    if (widget.series.isEmpty) widget.loadNextPage?.call();

    scrollController.addListener(() {
      final position = scrollController.position;
      if (position.pixels + 200 >= position.maxScrollExtent) {
        widget.loadNextPage?.call();
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SeriesHorizontalListview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // initState() only fires once per State object; Flutter reuses this same
    // State (calling didUpdateWidget instead) across rebuilds at the same
    // tree position. When a language switch recreates the underlying
    // provider, widget.series resets to empty but initState never reruns —
    // without this, the lazy-load bootstrap above would never re-fire.
    if (widget.series.isEmpty) widget.loadNextPage?.call();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Header(title: widget.title, subtitle: widget.subtitle),
          const SizedBox(height: 5),
          Expanded(
            child: widget.series.isEmpty
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.series.length,
                    itemBuilder: (context, index) => FadeInRight(
                      child: _Slide(series: widget.series[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.title, this.subtitle});
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subtitle!),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.series});
  final TvShow series;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: GestureDetector(
                onTap: () => context.push('/home/0/series/${series.id}'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AppNetworkImage(
                    imageUrl: series.posterPath.value(),
                    width: 150,
                    height: 200,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(series.name.value(), maxLines: 2, style: textTheme.titleSmall),
          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              const SizedBox(width: 3),
              Text(
                NumberFormat.decimalPatternDigits(
                  decimalDigits: 1,
                ).format(series.voteAverage.value()),
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              const Spacer(),
              Text(
                HumanFormats.number(series.popularity.value(), 2),
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
