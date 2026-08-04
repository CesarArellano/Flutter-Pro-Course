import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/app_language.dart';
import '../../../domain/entities/theme_preference.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  static const name = 'preferences-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themePreference = ref.watch(themePreferenceProvider);
    final appLanguage = ref.watch(appLanguageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferencesTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.themeLabel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l10n.lightLabel),
                    selected: themePreference == ThemePreference.light,
                    onSelected: (_) => ref
                        .read(themePreferenceProvider.notifier)
                        .setThemePreference(ThemePreference.light),
                  ),
                ),
                ChoiceChip(
                  label: Text(l10n.darkLabel),
                  selected: themePreference == ThemePreference.dark,
                  onSelected: (_) => ref
                      .read(themePreferenceProvider.notifier)
                      .setThemePreference(ThemePreference.dark),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.languageLabel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l10n.englishLabel),
                    selected: appLanguage == AppLanguage.en,
                    onSelected: (_) => ref
                        .read(appLanguageProvider.notifier)
                        .setAppLanguage(AppLanguage.en),
                  ),
                ),
                ChoiceChip(
                  label: Text(l10n.spanishLabel),
                  selected: appLanguage == AppLanguage.es,
                  onSelected: (_) => ref
                      .read(appLanguageProvider.notifier)
                      .setAppLanguage(AppLanguage.es),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
