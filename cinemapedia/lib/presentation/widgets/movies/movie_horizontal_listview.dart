import 'package:animate_do/animate_do.dart';
import 'package:clappy/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/movie.dart';
import '../shared/app_network_image.dart';

class MovieHorizontalListview extends StatefulWidget {
  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      final position = scrollController.position;
      if (position.pixels + 200 >= position.maxScrollExtent) {
        widget.loadNextPage?.call();
      }
    });
    super.initState();
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
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, index) =>
                  FadeInRight(child: _Slide(movie: widget.movies[index])),
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
  const _Slide({required this.movie});
  final Movie movie;

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
                onTap: () => context.push('/home/0/movie/${movie.id}'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AppNetworkImage(
                    imageUrl: movie.posterPath.value(),
                    width: 150,
                    height: 200,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(movie.title.value(), maxLines: 2, style: textTheme.titleSmall),
          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              const SizedBox(width: 3),
              Text(
                NumberFormat.decimalPatternDigits(
                  decimalDigits: 1,
                ).format(movie.voteAverage.value()),
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              const Spacer(),
              Text(
                HumanFormats.number(movie.popularity.value(), 2),
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
