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
    word.learn = value;
    await _dbService.updatePfIng(word);
    setState(() {}); // Refresca la UI después de la actualización
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Palabras Guardadas')),
      body: widget.words.isEmpty
          ? Center(child: Text('No hay palabras guardadas.'))
          : ListView.builder(
              itemCount: widget.words.length,
              itemBuilder: (context, index) {
                final word = widget.words[index];
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
                              onPressed: () => _updateLearnStatus(word, word.learn+1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text('Aprendido'),
                            ),
                            ElevatedButton(
                              onPressed: () => _updateLearnStatus(word, 0),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('No Aprendido'),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Estado: ${word.learn >= 2 ? "Aprendido ✅" : "No Aprendido ❌"}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
