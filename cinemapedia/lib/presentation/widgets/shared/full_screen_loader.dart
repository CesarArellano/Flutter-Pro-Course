import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

Stream<String> _getLoadingMessages(List<String> messages) {
  return Stream.periodic(const Duration(milliseconds: 1200), (step) {
    return messages[step % messages.length];
  });
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = [
      l10n.loadingMovies,
      l10n.buyingPopcorns,
      l10n.loadingPopulars,
      l10n.callingGirlfriend,
      l10n.almostThere,
      l10n.tookLongerThanExpected,
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.pleaseWait),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _getLoadingMessages(messages),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text(l10n.loadingEllipsis);
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
