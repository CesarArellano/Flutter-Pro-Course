import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.movie_outlined, color: colors.primary),
            const SizedBox(width: 5),
            Text('Cinemapedia', style: titleStyle,),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search)
            )
          ],
        ),
      ),
    );
  }
}