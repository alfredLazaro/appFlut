import 'dart:math';

import 'package:first_app/models/pf_ing_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/EnglishFlashCard.dart';
class FlashCardDeck extends StatelessWidget {
  final List<PfIng> flashCards;
  final Color cardColor;
  final void Function(PfIng word) onLearnedTap;
  final void Function(PfIng word) resetLearn;
  final void Function(PfIng word,String tesWord) isLearned;
  const FlashCardDeck({
    Key? key,
    required this.flashCards,
    required this.onLearnedTap,
    required this.resetLearn,
    required this.isLearned,
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
              bottom: i * 6,
              right: i * 6,
                child: SizedBox(
                  width: 300,
                  child: EnglishFlashCard(
                    key: ValueKey(flashCards[i].id),
                    wordData: flashCards[i],
                    learn: flashCards[i].learn,
                    word: flashCards[i].word,
                    imageUrl: flashCards[i].imageUrl ?? "ruta/defect.png",
                    onLearned: () => onLearnedTap(flashCards[i]),
                    resetLearn: ()=> resetLearn(flashCards[i]),
                    testingWord: (cad) => isLearned(flashCards[i],cad),//se supone que le envia la palabra desde el card
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