import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/presentation/providers/theme_provider.dart';

class ThemeChangerScreen extends ConsumerWidget {
  
  static const String name = 'theme_changer';
  
  const ThemeChangerScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Changer'),
        actions: [
          IconButton(
            onPressed: () {
              // ref.read(isDarkModeProvider.notifier).update((state) => !state);
              ref.read(themeNotifierProvider.notifier).toggleDarkMode();
            },
            icon: Icon( 
              isDarkMode 
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined
            ),
          )
        ],
      ),
      body: const _ThemeChangerView(),
    );
  }
}

class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Color> colorList = ref.watch(colorListProvider);
    final appTheme = ref.watch(themeNotifierProvider);
    // final int selectedColor = ref.watch(selectedColorProvider);


    return ListView.builder(
      itemCount: colorList.length,
      itemBuilder: (BuildContext context, int index) {
        final color = colorList[index];
        return RadioListTile(
          title: Text('This color', style: TextStyle(color: color)),
          subtitle: Text('${ color.value }'),
          activeColor: color,
          value: index,
          groupValue: appTheme.selectedColor,
          onChanged: ( value ) {
            ref.read(themeNotifierProvider.notifier).changerColorIndex(value ?? 0);
          }
        );
      },
    );
  }
}