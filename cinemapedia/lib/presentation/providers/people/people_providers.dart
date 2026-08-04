import 'package:clappy/domain/entities/person.dart';
import 'package:clappy/presentation/providers/people/people_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Calls loadNextPage() immediately on creation — see movies_providers.dart
// for why: this provider watches peopleRepositoryProvider, which rebuilds
// (dropping accumulated state) whenever the language preference changes.
final popularPeopleProvider =
    StateNotifierProvider<PeopleNotifier, List<Person>>((ref) {
      final fetchMorePeople = ref.watch(peopleRepositoryProvider).getPopular;

      return PeopleNotifier(fetchMorePeople: fetchMorePeople)..loadNextPage();
    });

// Definition of usecase
typedef PersonCallback = Future<List<Person>> Function({int page});

class PeopleNotifier extends StateNotifier<List<Person>> {
  PeopleNotifier({required this.fetchMorePeople}) : super([]);

  int currentPage = 0;
  bool isLoading = false;
  PersonCallback fetchMorePeople;

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;

    final List<Person> people = await fetchMorePeople(page: currentPage);
    if (!mounted) return;
    state = [...state, ...people];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
