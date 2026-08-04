import 'package:animate_do/animate_do.dart';
import 'package:clappy/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';
import '../shared/app_network_image.dart';

class MoviePosterLink extends StatelessWidget {
  const MoviePosterLink({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTap: () => context.push('/home/0/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AppNetworkImage(
            imageUrl: movie.posterPath.value(),
            width: MediaQuery.sizeOf(context).width / 3,
          ),
        ),
      ),
    );
  }
}
