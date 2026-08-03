import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../domain/entities/person.dart';
import '../widgets.dart';

class PersonMasonry extends StatefulWidget {
  const PersonMasonry({
    super.key,
    required this.people,
    required this.loadNextPage,
  });
  final List<Person> people;
  final VoidCallback loadNextPage;

  @override
  State<PersonMasonry> createState() => _PersonMasonryState();
}

class _PersonMasonryState extends State<PersonMasonry> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      final position = _scrollController.position;

      if (position.pixels + 100 >= position.maxScrollExtent) {
        widget.loadNextPage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.people.length,
        itemBuilder: (context, index) =>
            PersonCard(person: widget.people[index]),
      ),
    );
  }
}
