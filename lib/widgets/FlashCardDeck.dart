import 'package:first_app/models/pf_ing_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/EnglishFlashCard.dart';
class FlashCardDeck extends StatelessWidget {
  final List<PfIng> flashCards;
  final Color cardColor;
  final void Function(PfIng word) onLearnedTap;
  const FlashCardDeck(List<PfIng> notLearnedWords, {
    Key? key,
    required this.flashCards,
    required this.onLearnedTap,
    this.cardColor = Colors.white, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 370,
        height: 450,
        child: Stack(
          alignment: Alignment.center,
          children: flashCards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            return Positioned(
              bottom: index * 8, //da un desfase
              right: index * 8,
              child: SizedBox(
                width: 300,
                child: EnglishFlashCard(
                  key: ValueKey(card.id),
                  wordData: card,
                  learn: card.learn,
                  word: card.word,
                  imageUrl: '/ruta.png',
                  onLearned: () => onLearnedTap(card),
                  cardColor: cardColor,
                ),
              )
              
            );
          }).toList(),
          )
      )
    );
  }
}