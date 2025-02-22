import 'package:flutter/material.dart';
import 'pagina2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/database_service.dart';
import '../models/pf_ing_model.dart';

class Pagina1 extends StatefulWidget {
  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  TextEditingController _controller = TextEditingController();
  List<PfIng> _words = []; // Lista para almacenar palabras

  @override
  void initState() {
    super.initState();
    _loadWords(); // Cargar palabras al iniciar
  }

  Future<void> _loadWords() async {
    final words = await DatabaseService().getAllPfIng();
    setState(() {
      _words = words;
    });
  }

  Future<void> _saveWord() async {
    String word = _controller.text;
    if (word.isEmpty) return;

    // Crear el objeto y guardarlo en SQLite
    PfIng newWord = PfIng(id: 3, word: word, sentence: "Ejemplo de uso.");
    await DatabaseService().insertPfIng(newWord);

    _controller.clear();
    _loadWords(); // Recargar la lista después de guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Palabra en inglés que no entiendes'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Escribe la palabra',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveWord, // Guardar en SQLite
              child: Text('Guardar Palabra'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_words[index].word),
                    subtitle: Text(_words[index].sentence),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseService().deletePfIng(_words[index].id!);
                        _loadWords();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
