import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class MoviesSlideshow extends StatefulWidget {
  final List<Movie> movies;

  const MoviesSlideshow({
    super.key,
    required this.movies
  });

  @override
  State<MoviesSlideshow> createState() => _MoviesSlideshowState();
}

class _MoviesSlideshowState extends State<MoviesSlideshow> {
  final CarouselController _controller = CarouselController();
  Timer? _autoplayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _autoplayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if( widget.movies.length < 2 ) return;

      final nextPage = (_currentPage + 1) % widget.movies.length;
      _controller.animateToItem(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final itemExtent = MediaQuery.sizeOf(context).width * 0.8;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselView(
            controller: _controller,
            itemExtent: itemExtent,
            shrinkExtent: itemExtent * 0.9,
            itemSnapping: true,
            infinite: widget.movies.length > 1,
            enableSplash: false,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            onIndexChanged: (index) => setState(() => _currentPage = index),
            children: widget.movies
              .map((movie) => _Slide(movie: movie))
              .toList(),
          ),
          if( widget.movies.length > 1 )
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _PageIndicator(
                itemCount: widget.movies.length,
                currentPage: _currentPage,
                activeColor: colors.primary,
                inactiveColor: colors.secondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.itemCount,
    required this.currentPage,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int itemCount;
  final int currentPage;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.movie
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 10)
        )
      ]
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath.value(),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if( loadingProgress != null ) {
                return const DecoratedBox(
                  decoration: BoxDecoration( color: Colors.black12),
                );
              }

              return GestureDetector(
                child: FadeIn(child: child),
                onTap: () => context.push('/home/0/movie/${ movie.id }'),
              );
            },
          )
        ),
      )
    );
  }
}
