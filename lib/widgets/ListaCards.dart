
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:first_app/models/pf_ing_model.dart';
import 'package:first_app/services/database_service.dart'; 
class ListaCards extends StatefulWidget{
  final List<PfIng> lswords;
  const ListaCards({
    Key? key,
    required this.lswords,
    }) : super(key: key);

  @override
  State<ListaCards> createState() => _ListaCardState();
}

class _ListaCardState extends State<ListaCards> {

  FlutterTts flutterTts = FlutterTts();
  DatabaseService _dbService = DatabaseService();
  late List<PfIng> _lisWords;
  @override
  void initState(){
    super.initState();
    _dbService=DatabaseService();
    _lisWords=widget.lswords;
  }

  Future<void> speakf(String text) async {
    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
    } catch (e) {
      print('Error al leer el texto: $e');
    }
  }

  Future<void> _updateLearnStatus(PfIng word, int value) async {
    await _dbService.updatePfIng(word..learn = value);
  }
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        _buildWordList(_lisWords),
      ],
    );
  }
  
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
                      onPressed: ()=> speakf(word.sentence),//reproduce la palabra
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
                      onPressed: ()=> speakf(word.word),
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