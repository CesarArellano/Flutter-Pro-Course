import 'dart:async';

import 'package:clappy/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/providers.dart';
import 'app_network_image.dart';

class _SlideItem {
  const _SlideItem({
    required this.imageUrl,
    required this.title,
    required this.voteAverage,
    required this.routePath,
  });
  final String imageUrl;
  final String title;
  final double voteAverage;
  final String routePath;
}

class ContentSlideshow extends ConsumerStatefulWidget {
  const ContentSlideshow({super.key});

  @override
  ConsumerState<ContentSlideshow> createState() => _ContentSlideshowState();
}

class _ContentSlideshowState extends ConsumerState<ContentSlideshow> {
  final CarouselController _controller = CarouselController();
  Timer? _autoplayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final slideCount = _readSlides().length;
      if (slideCount < 2) return;

      final nextPage = (_currentPage + 1) % slideCount;
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

  List<_SlideItem> _watchSlides() => switch (ref.watch(contentTypeProvider)) {
    ContentType.movies =>
      ref
          .watch(moviesSlideshowProvider)
          .map(
            (movie) => _SlideItem(
              imageUrl: movie.backdropPath.value(),
              title: movie.title.value(),
              voteAverage: movie.voteAverage.value(),
              routePath: '/home/0/movie/${movie.id}',
            ),
          )
          .toList(),
    ContentType.series =>
      ref
          .watch(seriesSlideshowProvider)
          .map(
            (series) => _SlideItem(
              imageUrl: series.backdropPath.value(),
              title: series.name.value(),
              voteAverage: series.voteAverage.value(),
              routePath: '/home/0/series/${series.id}',
            ),
          )
          .toList(),
  };

  // Same shape as _watchSlides but via ref.read, for use in the autoplay
  // timer callback (outside build, where watching would be a no-op anyway).
  List<_SlideItem> _readSlides() => switch (ref.read(contentTypeProvider)) {
    ContentType.movies =>
      ref
          .read(moviesSlideshowProvider)
          .map(
            (movie) => _SlideItem(
              imageUrl: movie.backdropPath.value(),
              title: movie.title.value(),
              voteAverage: movie.voteAverage.value(),
              routePath: '/home/0/movie/${movie.id}',
            ),
          )
          .toList(),
    ContentType.series =>
      ref
          .read(seriesSlideshowProvider)
          .map(
            (series) => _SlideItem(
              imageUrl: series.backdropPath.value(),
              title: series.name.value(),
              voteAverage: series.voteAverage.value(),
              routePath: '/home/0/series/${series.id}',
            ),
          )
          .toList(),
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final itemExtent = MediaQuery.sizeOf(context).width * 0.8;
    final slides = _watchSlides();

    if (slides.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselView(
            controller: _controller,
            itemExtent: itemExtent,
            shrinkExtent: itemExtent * 0.9,
            itemSnapping: true,
            infinite: slides.length > 1,
            enableSplash: false,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            onIndexChanged: (index) => setState(() => _currentPage = index),
            children: slides.map((slide) => _Slide(slide: slide)).toList(),
          ),
          if (slides.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _PageIndicator(
                itemCount: slides.length,
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
  const _Slide({required this.slide});

  final _SlideItem slide;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(
                imageUrl: slide.imageUrl,
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: 210,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.6],
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 10,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        slide.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.yellow.shade700, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      NumberFormat.decimalPatternDigits(
                        decimalDigits: 1,
                      ).format(slide.voteAverage),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push(slide.routePath),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
