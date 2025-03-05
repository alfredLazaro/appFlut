import 'package:first_app/models/pf_ing_model.dart';
import 'package:flutter/material.dart';
import 'EnglishFlashcard.dart';
class FlashCardDeck extends StatelessWidget {
  final List<PfIng> flashCards;
  final Color cardColor;

  const FlashCardDeck(List<PfIng> notLearnedWords, {
    Key? key,
    required this.flashCards,
    this.cardColor = Colors.white, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: flashCards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20,),
      itemBuilder: (context, index){
        final card = flashCards[index];
        return EnglishFlashCard(
          word: card.word ?? '',
          definition: "sdfas" ?? '',
          exampleSentence: card.sentence?? '',
          imageUrl: '/ruta.png'?? '',
          cardColor: cardColor,
        );
      }
    );
  }
}