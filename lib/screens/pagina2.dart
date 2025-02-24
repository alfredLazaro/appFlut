import 'package:flutter/material.dart';
import '../models/pf_ing_model.dart';
import '../services/database_service.dart'; // Importa DatabaseService

class Pagina2 extends StatefulWidget {
  final List<PfIng> words;

  Pagina2({required this.words});

  @override
  _Pagina2State createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {
  final DatabaseService _dbService = DatabaseService();

  // Función para actualizar el estado de aprendizaje de la palabra
  Future<void> _updateLearnStatus(PfIng word, int value) async {
    setState(() {
      word.learn = value;
    });
    await _dbService.updatePfIng(word);
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar palabras en dos categorías
    List<PfIng> notLearnedWords = widget.words.where((word) => word.learn < 3).toList();
    List<PfIng> learnedWords = widget.words.where((word) => word.learn >= 3).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Palabras Guardadas'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'No Aprendido ❌'),
              Tab(text: 'Aprendido ✅'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildWordList(notLearnedWords),
            _buildWordList(learnedWords),
          ],
        ),
      ),
    );
  }

  // Widget que genera la lista de palabras
  Widget _buildWordList(List<PfIng> words) {
    if (words.isEmpty) {
      return Center(child: Text('No hay palabras en esta sección.'));
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
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.sentence,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  word.word,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _updateLearnStatus(word, word.learn + 1),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Aprendido'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateLearnStatus(word, 0),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('No Aprendido'),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Estado: ${word.learn >= 3 ? "Aprendido ✅" : "No Aprendido ❌"}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
