import 'package:cinemapedia/presentation/views/views.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

const viewRoutes = <Widget> [
  HomeView(),
  CategoriesView(),
  FavoritesView()
];

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  final int pageViewIndex;

  const HomeScreen({
    Key? key,
    required this.pageViewIndex,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageViewIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        pageViewIndex: pageViewIndex,
      ),
    );
  }
}

