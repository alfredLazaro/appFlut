import 'package:flutter/material.dart';
import '../models/pf_ing_model.dart';
import '../services/database_service.dart'; // Importa DatabaseService
import 'package:flutter_tts/flutter_tts.dart';
class Pagina2 extends StatefulWidget {
  final List<PfIng> words;
  Pagina2({required this.words});

  @override
  _Pagina2State createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {
  FlutterTts flutterTts=FlutterTts();
  final DatabaseService _dbService = DatabaseService();

  late List<PfIng> _notLearnedWords;
  late List<PfIng> _learnedWords;
  //funcion de audio
  Future<void> speak(String text) async{
    try{
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
    } catch (e) {
      print("Error al leer el texto: $e");
    }
  }

  // Función para actualizar el estado de aprendizaje de la palabra
  Future<void> _updateLearnStatus(PfIng word, int value) async {
    setState(() {
      word.learn = value;
    });
    await _dbService.updatePfIng(word);
  }

  void _filterWords() {
    _notLearnedWords = widget.words.where((word) => word.learn < 3).toList();
    _learnedWords = widget.words.where((word) => word.learn >= 3).toList();
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
            _buildWordList(_notLearnedWords),
            _buildWordList(_learnedWords),
          ],
        ),
      ),
    );
  }

  // Widget que genera la lista de palabras
  Widget _buildWordList(List<PfIng> words) {
    if (words.isEmpty) {
      return const Center(child: Text('No hay palabras en esta sección.'));
    }

    // Ordena las palabras, moviendo las que tienen 'learn' == 1 al final de la lista
    words.sort((a, b) {
      if (a.learn == 1 && b.learn != 1) {
        return 1; // Mover la palabra 'a' al final
      } else if (a.learn != 1 && b.learn == 1) {
        return -1; // Mover la palabra 'b' al final
      } else {
        return 0; // Mantener el orden si ambos tienen el mismo valor de 'learn'
      }
    });
    
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Palabra con icono de parlante
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        word.sentence,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Opcional: Agrega "..." si es muy largo
                        maxLines: 3, // Limita a 2 líneas
                      ),
                    ),
                    const SizedBox(width:10),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: ()=> speak(word.sentence),//reproduce la palabra
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // icono
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [    
                    Text(
                      word.word,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    const SizedBox(width:10),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: ()=> speak(word.word),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _updateLearnStatus(word, word.learn + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black),
                      child: const Text('Aprendido'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateLearnStatus(word, 0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                      child: const Text('No Aprendido'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Estado: ${word.learn >= 3 ? "Aprendido ✅" : "No Aprendido ❌"}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
