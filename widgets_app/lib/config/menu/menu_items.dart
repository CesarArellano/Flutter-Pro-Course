import 'package:flutter/material.dart' show IconData, Icons;
import 'package:widgets_app/presentation/screens/animated/animated_screen.dart';

import '../../presentation/screens/screens.dart';

class MenuItem {
  final String title;
  final String subtitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.link,
    required this.icon
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Counter',
    subtitle: 'Default Counter',
    link: CounterScreen.name,
    icon: Icons.numbers
  ),
  MenuItem(
    title: 'Buttons',
    subtitle: 'Several buttons in Flutter',
    link: ButtonsScreen.name,
    icon: Icons.smart_button_outlined
  ),
  MenuItem(
    title: 'Cards',
    subtitle: 'A styled container',
    link: CardsScreen.name,
    icon: Icons.credit_card
  ),
  MenuItem(
    title: 'Progress Indicators',
    subtitle: 'General and controlled',
    link: ProgressScreen.name,
    icon: Icons.refresh
  ),
  MenuItem(
    title: 'Snackbars and dialogs',
    subtitle: 'Indicators on screen',
    link: SnackbarScreen.name,
    icon: Icons.info_outline
  ),
  MenuItem(
    title: 'Animated Container',
    subtitle: 'Stateful widget animated',
    link: AnimatedScreen.name,
    icon: Icons.check_box_outline_blank
  ),
  MenuItem(
    title: 'UI Controls + Tiles',
    subtitle: 'A serie of Flutter Controls',
    link: UiControlsScreen.name,
    icon: Icons.car_rental_sharp
  ),
  MenuItem(
    title: 'App Tutorial',
    subtitle: 'Small introductory tutorial',
    link: AppTutorialScreen.name,
    icon: Icons.accessible_outlined
  ),
  MenuItem(
    title: 'InfiniteScroll and Pull',
    subtitle: 'Infinite Lists and Pull to Refresh',
    link: InfiniteScrollScreen.name,
    icon: Icons.list_alt_outlined
  ),

  MenuItem(
    title: 'Theme Changer',
    subtitle: 'Change Theme App',
    link: ThemeChangerScreen.name,
    icon: Icons.list_alt_outlined
  ),
];