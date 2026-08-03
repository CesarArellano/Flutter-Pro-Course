import 'package:drift/drift.dart';

import '../../domain/datasources/local_storage_datasource.dart';
import '../../domain/entities/movie.dart';
import 'drift/app_database.dart';

class DriftDatasource implements LocalStorageDatasource {
  DriftDatasource() : db = AppDatabase();
  final AppDatabase db;

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final favoriteMovie = await (db.select(
      db.moviesTable,
    )..where((movie) => movie.id.equals(movieId))).getSingleOrNull();

    return favoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) async {
    final entries = await (db.select(
      db.moviesTable,
    )..limit(limit, offset: offset)).get();

    return entries.map(_entryToMovie).toList();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final favoriteMovie = await (db.select(
      db.moviesTable,
    )..where((entry) => entry.id.equals(movie.id!))).getSingleOrNull();

    if (favoriteMovie != null) {
      await (db.delete(
        db.moviesTable,
      )..where((entry) => entry.id.equals(movie.id!))).go();
      return;
    }

    await db.into(db.moviesTable).insert(_movieToCompanion(movie));
  }

  Movie _entryToMovie(MovieEntry entry) => Movie(
    adult: entry.adult,
    backdropPath: entry.backdropPath,
    genreIds: _decodeGenreIds(entry.genreIds),
    id: entry.id,
    originalLanguage: entry.originalLanguage,
    originalTitle: entry.originalTitle,
    overview: entry.overview,
    popularity: entry.popularity,
    posterPath: entry.posterPath,
    releaseDate: entry.releaseDate,
    title: entry.title,
    video: entry.video,
    voteAverage: entry.voteAverage,
    voteCount: entry.voteCount,
    budget: entry.budget,
    revenue: entry.revenue,
    runtime: entry.runtime,
    heroId: entry.heroId,
  );

  MoviesTableCompanion _movieToCompanion(Movie movie) =>
      MoviesTableCompanion.insert(
        id: Value(movie.id!),
        adult: Value(movie.adult),
        backdropPath: Value(movie.backdropPath),
        genreIds: Value(_encodeGenreIds(movie.genreIds)),
        originalLanguage: Value(movie.originalLanguage),
        originalTitle: Value(movie.originalTitle),
        overview: Value(movie.overview),
        popularity: Value(movie.popularity),
        posterPath: Value(movie.posterPath),
        releaseDate: Value(movie.releaseDate),
        title: Value(movie.title),
        video: Value(movie.video),
        voteAverage: Value(movie.voteAverage),
        voteCount: Value(movie.voteCount),
        budget: Value(movie.budget),
        revenue: Value(movie.revenue),
        runtime: Value(movie.runtime),
        heroId: Value(movie.heroId),
      );

  String? _encodeGenreIds(List<String>? genreIds) => genreIds?.join(',');

  List<String>? _decodeGenreIds(String? raw) {
    if (raw == null) return null;
    if (raw.isEmpty) return [];
    return raw.split(',');
  }
}
