import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ContentType { movies, series }

extension ContentTypeLabel on ContentType {
  String get label => switch (this) {
    ContentType.movies => 'Movies',
    ContentType.series => 'Series',
  };
}

final contentTypeProvider = StateProvider<ContentType>(
  (ref) => ContentType.movies,
);
