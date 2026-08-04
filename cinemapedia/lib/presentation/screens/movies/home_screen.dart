import 'dart:async';

import 'package:clappy/presentation/views/views.dart';
import 'package:clappy/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.pageIndex});

  static const name = 'home-screen';
  final int pageIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//* Este Mixin es necesario para mantener el estado en el PageView
class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewRoutes = const <Widget>[
    HomeView(),
    PopularView(), // <--- categorias View
    PopularPeopleView(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (pageController.hasClients) {
      unawaited(
        pageController.animateToPage(
          widget.pageIndex,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 250),
        ),
      );
    }

    return Scaffold(
      // CustomAppbar is mounted once here, overlaid above the PageView,
      // instead of duplicated inside every tab — each tab only needs to pad
      // its own scrollable content by CustomAppbar.height(context) so it
      // starts below the bar and scrolls up underneath its blur.
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: viewRoutes,
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: CustomAppbar()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        pageViewIndex: widget.pageIndex,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
