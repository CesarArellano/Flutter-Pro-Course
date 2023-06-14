import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/movie.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subtitle,
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      final position = scrollController.position;
      if( position.pixels + 200 >= position.maxScrollExtent ) {
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
          if( widget.title != null || widget.subtitle != null )
            _Header(
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (context, index) => FadeInRight(
                child: _Slide(
                  movie: widget.movies[index]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Header({
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if( title != null )
            Text(title!, style: const TextStyle( fontSize: 22, fontWeight: FontWeight.bold)),
          const Spacer(),
          if( subtitle != null )
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subtitle!)
            )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  
  const _Slide({
    required this.movie
  });

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath.value(),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if( loadingProgress != null ) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    }
                      
                    return GestureDetector(
                      child: FadeIn(child: child),
                      onTap: () => context.push('/home/0/movie/${ movie.id }'),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title.value(),
            maxLines: 2,
            style: textTheme.titleSmall,
          ),
          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              const SizedBox(width: 3),
              Text(
                '${ movie.voteAverage }',
                style: textTheme.bodyMedium?.copyWith(color:  Colors.yellow.shade800)
              ),
              const Spacer(),
              Text(
                HumanFormats.number(movie.popularity.value()),
                style: textTheme.bodySmall
              ),
            ],
          )
        ],
      ),
    );
  }
}