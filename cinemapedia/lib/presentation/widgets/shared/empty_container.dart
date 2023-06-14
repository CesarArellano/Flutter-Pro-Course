import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Icon(
        Icons.movie_outlined,
        size: 130,
        color:  isDarkTheme ?  Colors.white70 : Colors.black26,
      )
    );
  }
}