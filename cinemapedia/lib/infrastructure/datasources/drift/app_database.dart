import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('MovieEntry')
class MoviesTable extends Table {
  @override
  String get tableName => 'movies';

  IntColumn get id => integer()();
  BoolColumn get adult => boolean().nullable()();
  TextColumn get backdropPath => text().nullable()();
  TextColumn get genreIds => text().nullable()();
  TextColumn get originalLanguage => text().nullable()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get overview => text().nullable()();
  RealColumn get popularity => real().nullable()();
  TextColumn get posterPath => text().nullable()();
  DateTimeColumn get releaseDate => dateTime().nullable()();
  TextColumn get title => text().nullable()();
  BoolColumn get video => boolean().nullable()();
  RealColumn get voteAverage => real().nullable()();
  IntColumn get voteCount => integer().nullable()();
  IntColumn get budget => integer().nullable()();
  IntColumn get revenue => integer().nullable()();
  IntColumn get runtime => integer().nullable()();
  TextColumn get heroId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [MoviesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'clappy');
  }
}
