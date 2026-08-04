import 'package:clappy/domain/entities/person.dart';
import 'package:clappy/presentation/providers/people/people_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personInfoProvider =
    StateNotifierProvider<PersonMapNotifier, Map<String, Person>>((ref) {
      final peopleRepository = ref.watch(peopleRepositoryProvider);
      return PersonMapNotifier(getPerson: peopleRepository.getPersonById);
    });

typedef GetPersonCallback = Future<Person> Function(String personId);

class PersonMapNotifier extends StateNotifier<Map<String, Person>> {
  PersonMapNotifier({required this.getPerson}) : super({});
  final GetPersonCallback getPerson;

  Future<void> loadPerson(String personId) async {
    if (state[personId] != null) return;

    final person = await getPerson(personId);
    if (!mounted) return;

    state = {...state, personId: person};
  }
}
