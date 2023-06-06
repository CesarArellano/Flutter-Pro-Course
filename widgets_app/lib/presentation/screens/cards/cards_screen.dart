import 'package:flutter/material.dart';
import 'package:widgets_app/infrastructure/models/card_model.dart';

const List<CardModel> cards = <CardModel>[
  CardModel(elevation: 0.0, text: 'Elevation 0.0'),
  CardModel(elevation: 1.0, text: 'Elevation 1.0'),
  CardModel(elevation: 2.0, text: 'Elevation 2.0'),
  CardModel(elevation: 3.0, text: 'Elevation 3.0'),
  CardModel(elevation: 4.0, text: 'Elevation 4.0'),
  CardModel(elevation: 5.0, text: 'Elevation 5.0'),
];

class CardsScreen extends StatelessWidget {
  static const String name = 'cards_screen';
  
  const CardsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards Screen'),
      ),
      body: const _CardsView()
    );
  }
}

class _CardsView extends StatelessWidget {
  const _CardsView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...cards.map(
            (card) => _CardType1( card: card )
          ),
          ...cards.map(
            (card) => _CardType2( card: card )
          ),
          ...cards.map(
            (card) => _CardType3( card: card )
          ),
        ]
      ),
    );
  }
}

class _CardType1 extends StatelessWidget {
  const _CardType1({
    required this.card
  });

  final CardModel card;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: card.elevation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: (){},
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(card.text)
            ),
          ],
        ),
      ),
    );
  }
}

class _CardType2 extends StatelessWidget {
  const _CardType2({
    required this.card
  });

  final CardModel card;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colors.outline
        )
      ),
      elevation: card.elevation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: (){},
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text('${ card.text } - outline')
            ),
          ],
        ),
      ),
    );
  }
}

class _CardType3 extends StatelessWidget {
  const _CardType3({
    required this.card
  });

  final CardModel card;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: card.elevation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Stack(
          children: [
            Image.network(
              'https://picsum.photos/id/${ card.elevation.toInt() }/600/250',
              height: 350,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  onPressed: (){},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}