import 'package:flutter/material.dart';
import 'pagina2.dart'; // Importa la segunda página
import '../services/database_service.dart'; // Importa el servicio de base de datos
import '../models/pf_ing_model.dart'; // Importa el modelo

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

  // Cargar palabras desde la base de datos
  Future<void> _loadWords() async {
    final words = await DatabaseService().getAllPfIng();
    setState(() {
      _words = words;
    });
  }

  // Guardar una nueva palabra en la base de datos
  Future<void> _saveWord() async {
    String word = _controller.text;
    if (word.isEmpty) return;

    // Crear el objeto y guardarlo en SQLite
    PfIng newWord = PfIng(id: 3, word: word, sentence: "Ejemplo de uso.");
    await DatabaseService().insertPfIng(newWord);

    _controller.clear(); // Limpiar el TextField
    _loadWords(); // Recargar la lista después de guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Principal'),
        actions: [
          // Botón en el AppBar para ir a la segunda página
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pagina2(words: _words)),
              );
            },
          ),
        ],
      ),
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
            SizedBox(height: 10),
            // Botón adicional para ir a la segunda página
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pagina2(words: _words)),
                );
              },
              child: Text('Ir a la segunda página'),
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