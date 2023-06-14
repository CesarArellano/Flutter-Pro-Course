import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.pageViewIndex,
  });

  final int pageViewIndex;

  void onItemTapped( BuildContext context, int index ) {
    context.go('/home/$index');
  } 

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageViewIndex,
      onTap: (value) => onItemTapped(context, value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Populars'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorites'
        ),
      ],
    );
  }
}