import 'dart:math';

import 'package:first_app/models/pf_ing_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/EnglishFlashCard.dart';
class FlashCardDeck extends StatelessWidget {
  final List<PfIng> flashCards;
  final Color cardColor;
  final void Function(PfIng word) onLearnedTap;
  const FlashCardDeck({
    Key? key,
    required this.flashCards,
    required this.onLearnedTap,
    this.cardColor = Colors.white, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < min(flashCards.length, 5); i++) // Mostrar máximo 5
            Positioned(
              bottom: i * 4,
              right: i * 4,
                child: SizedBox(
                  width: 300,
                  child: EnglishFlashCard(
                    key: ValueKey(flashCards[i].id),
                    wordData: flashCards[i],
                    learn: flashCards[i].learn,
                    word: flashCards[i].word,
                    imageUrl: '/ruta.png',
                    onLearned: () => onLearnedTap(flashCards[i]),
                    cardColor: cardColor,
                  ),
                ),
            ),
        ],
      ),
    ),
  );
}

}