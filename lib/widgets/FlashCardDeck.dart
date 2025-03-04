import 'package:flutter/material.dart';
import 'EnglishFlashcard.dart';
class FlashCardDeck extends StatelessWidget {
  final List<Map<String, String>> flashCards;
  final Color cardColor;

  const FlashCardDeck({
    Key? key,
    required this.flashCards,
    this.cardColor = Colors.white, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: flashCards.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20,),
      itemBuilder: (context, index){
        final card = flashCards[index];
        return EnglishFlashCard(
          word: card['word'] ?? '',
          definition: card['definition'] ?? '',
          exampleSentence: card['exampleSentence']?? '',
          imageUrl: card['imageUrl'] ?? '',
          cardColor: cardColor,
        );
      }
    );
  }
}