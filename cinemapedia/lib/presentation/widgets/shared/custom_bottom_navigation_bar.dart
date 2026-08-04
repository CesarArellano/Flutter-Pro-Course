import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.pageViewIndex});

  final int pageViewIndex;

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: pageViewIndex,
      onTap: (value) => onItemTapped(context, value),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_max),
          label: l10n.navHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.label_outline),
          label: l10n.navPopulars,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.people_outline),
          label: l10n.navPeople,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          label: l10n.navFavorites,
        ),
      ],
    );
  }
}
