import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../config/extensions/null_extensions.dart';
import '../../../domain/entities/actor.dart';
import '../../../domain/entities/movie.dart';
import '../../providers/movies/movie_info_provider.dart';

class MovieScreen extends ConsumerStatefulWidget {
  
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    Key? key,
    required this.movieId
  }) : super(key: key);

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadCast(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    
    if( movie == null ) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(movie: movie),
          SliverToBoxAdapter(
            child: _MovieDetails(movie: movie),
          )
        ],
      ),
    );
  }
}


class _CustomSliverAppbar extends StatelessWidget {
  const _CustomSliverAppbar({
    required this.movie,
  });

  final Movie movie;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      expandedHeight: size.height * 0.7,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath.value(),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  
                  if(loadingProgress != null) return const SizedBox();

                  return FadeIn(child: child);
                },
              )
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [ 0.0, 0.2 ],
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ]
                  )
                ),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [ 0.0, 0.3 ],
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ]
                  )
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: (){},
          icon: const Icon(Icons.favorite_border_outlined)
        )
      ],
    );
  }
}


class _MovieDetails extends StatelessWidget {
  const _MovieDetails({
    required this.movie,
  });

  final Movie movie;
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    const TextStyle chipTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath.value(),
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? 'No title',
                      style: textStyles.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.originalTitle.value(),
                      style: textStyles.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          backgroundColor: Colors.black,
                          label: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow),
                              const SizedBox(width: 5),
                              Text(
                                NumberFormat.decimalPatternDigits(decimalDigits: 2).format(movie.voteAverage ),
                                style: chipTextStyle
                              ),
                            ]
                          ),
                        ),
                        const SizedBox(width: 10),
                        if( movie.adult.value() )
                          const Chip(
                            backgroundColor: Colors.red,
                            label: Text('+18', style: chipTextStyle )
                          )
                      ],
                    )
              
                  ],
                ),
              )
            ]
          )
        ),
        _Overview(movie: movie),
        _MoreDetails( movie: movie ),
        _ActorsByMovie(
          movieId: movie.id.toString()
        ),
        const SizedBox(height: 10)
      ]
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview', style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold) ),
          const SizedBox(height: 5),
          Text(
            movie.overview.value(),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class _MoreDetails extends StatelessWidget {

  const _MoreDetails({
    Key? key,
    required this.movie
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final numberFormater = NumberFormat("\$#,##0.00 USD", "en_US");

    final releaseDate = movie.releaseDate ?? DateTime.now();
    final budget = numberFormater.format( movie.budget );
    final revenue = numberFormater.format( movie.revenue );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text('Details', style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6,
            children: [
              Text('Género(s):', style: textTheme.titleSmall),
              ...(movie.genreIds ?? [] ).map((genre) => Text(
                (genre != movie.genreIds?.last) ? '$genre,' : '$genre.',
                style: textTheme.titleSmall
              ))
            ],
          ),
          Text('Release date: ${ releaseDate.day }-${ releaseDate.month }-${ releaseDate.year }', style: textTheme.titleSmall),
          const SizedBox(height: 5),
          Text('Duration: ${ durationToString(movie.runtime!) }h', style: textTheme.titleSmall),
          const SizedBox(height: 5),
          Text('Budget: $budget', style: textTheme.titleSmall),
          const SizedBox(height: 5),
          Text('Revenue: $revenue', style: textTheme.titleSmall),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}

class _ActorsByMovie extends ConsumerWidget {
  const _ActorsByMovie({
    required this.movieId
  });

  final String movieId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actors = ref.watch(actorsByMovieProvider)[movieId] ?? [];
    
    if( actors.isEmpty ) {
      return const Center(
        child: CircularProgressIndicator()
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) => _CastCard(
          actor: actors[index]
        ),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final Actor actor;

  const _CastCard({ 
    Key? key,
    required this.actor 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/loading.gif'),
              image: NetworkImage( actor.profilePath ),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 170,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text( 
              actor.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text( 
              actor.character.value('No-character'),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}