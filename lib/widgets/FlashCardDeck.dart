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
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Center(
      child: SizedBox(
        width: min(400.0, screenSize.width* 0.95),//ancho maximo de 400 0 de 95% de pantalla
        height: isPortrait ? screenSize.height * 0.65: screenSize.height * 0.8,
        
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < min(flashCards.length, 5); i++) // Mostrar máximo 5
              Positioned(
                bottom: i * 5,
                right: i * 5,
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: EnglishFlashCard(
                      key: ValueKey(flashCards[i].id),
                      wordData: flashCards[i],
                      learn: flashCards[i].learn,
                      word: flashCards[i].word,
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