import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';

enum ContentType { movies, series }

extension ContentTypeLabel on ContentType {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ContentType.movies => l10n.contentTypeMovies,
      ContentType.series => l10n.contentTypeSeries,
    };
  }
}

final contentTypeProvider = StateProvider<ContentType>(
  (ref) => ContentType.movies,
);
