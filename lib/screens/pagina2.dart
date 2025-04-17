import 'package:flutter/material.dart';
import '../models/pf_ing_model.dart';
import '../services/database_service.dart'; // Importa DatabaseService
import 'package:flutter_tts/flutter_tts.dart';
import 'package:first_app/widgets/FlashCardDeck.dart';
class Pagina2 extends StatefulWidget {
  final List<PfIng> words;
  Pagina2({required this.words});
  @override
  _Pagina2State createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {
  FlutterTts flutterTts=FlutterTts();
  final DatabaseService _dbService = DatabaseService();
  late List<PfIng> notLearnedWords;
  late List<PfIng> _learnedWords;
  final nroRepetitions = 4; // Número de repeticiones para considerar "aprendido"
  @override
  void initState(){
    super.initState();
    _filterWords(); //inicializa 
  }

  // Función para actualizar el estado de aprendizaje de la palabra
  Future<void> _updateLearnStatus(PfIng word, int value) async {
    await _dbService.updatePfIng(word..learn = value);
  }

  void _filterWords() {
    setState(() {
      notLearnedWords = widget.words.where((word) => word.learn < nroRepetitions).toList();
      _learnedWords = widget.words.where((word) => word.learn >= nroRepetitions).toList();
    });
  }

  //funcione reinicio de aprendizaje
  void resetLearn(PfIng word){
    setState(() {
      _updateLearnStatus(word,0);
    });
    _learnedWords.remove(word);
    notLearnedWords.add(word);
  }

  void onLearnedTap(PfIng word) {
      _updateLearnStatus(word, word.learn+1); //actualizar el valor
    setState((){
      notLearnedWords.remove(word);
      if(word.learn<nroRepetitions){
        notLearnedWords.insert(0,word);
      }else{
        _learnedWords.add(word);
      }
    });
    //  _filterWords(); // Actualizar las listas después de la actualización
  }
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Palabras Guardadas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'No Aprendido ❌'),
              Tab(text: 'Aprendido ✅'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FlashCardDeck(flashCards: notLearnedWords, onLearnedTap: onLearnedTap, resetLearn: resetLearn),
            FlashCardDeck(flashCards: _learnedWords, onLearnedTap: onLearnedTap, resetLearn: resetLearn),
          ],
        ),
      ),
    );
  }
}
