import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/extensions/null_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class MoviePosterLink extends StatelessWidget {
  
  final Movie movie;
  
  const MoviePosterLink({
    Key? key,
    required this.movie
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTap: () => context.push('/home/0/movie/${ movie.id }'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeIn(
            child: Image.network(
              movie.posterPath.value(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}