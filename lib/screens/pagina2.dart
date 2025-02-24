import 'package:flutter/material.dart';
import '../models/pf_ing_model.dart'; // Importa el modelo

class Pagina2 extends StatelessWidget {
  final List<PfIng> words; // Lista de palabras recibida desde Pagina1

  // Constructor que recibe la lista de palabras
  Pagina2({required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página 2'),
      ),
      body: Center(
        child: words.isEmpty
            ? Text('No hay palabras guardadas.') // Mensaje si la lista está vacía
            : ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(words[index].sentence),
                    subtitle: Text(words[index].word),
                  );
                },
              ),
      ),
    );
  }
}