import 'package:first_app/services/dictonary_service.dart';
import 'package:flutter/material.dart';
import 'pagina2.dart';
import '../services/database_service.dart';
import '../models/pf_ing_model.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // Para el reconocimiento de voz
import 'package:logger/logger.dart';
import 'package:first_app/services/apiImage.dart';
class Pagina1 extends StatefulWidget {
  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  final loger=Logger();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _creado = TextEditingController();
  //hablar a texto
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<PfIng> _words = [];
  final WordService _wordService = WordService();

  //api para imagenes
  final apiImg=ImageService();

  @override
  void initState() {
    super.initState();
    _loadWords();
    _speech = stt.SpeechToText();
  }
  //funcion para iniciar y detener el texto a voz
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => loger.d('onStatus: $val'),
        onError: (val) => loger.d('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            //_text = val.recognizedWords;
            _controller.text = val.recognizedWords; //
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
    
    final data = await obtenerDatos(word);
    final imgagen= await getImages(word);
    PfIng newWord = PfIng(
      definicion: data['definition'] ?? 'no hay definicion',
      word: word,
      sentence: data['example'] ?? 'no hay ejemplo',
      learn: 0,
      imageUrl: '',
      context: "",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    await DatabaseService().insertPfIng(newWord);
    _controller.clear();
    _loadWords();

  }

  Future<Map<String,dynamic>> obtenerDatos(String word) async {
    try{
      final value = await _wordService.getWordDefinition(word);
      loger.d(".....................servicio diccionario......................................");
      loger.d(value);
      return value;
    }catch(e){
      loger.d("Error al obtener datos: $e");
      return {
        'definition': 'No se encontró la definición',
        'example': 'No se encontró el ejemplo'
      };
    }
  }

  Future<Map<String,dynamic>> getImages(String word) async{
    try{
      final value= await apiImg.getImg(word);
      loger.d(value['results']);
      // Mapeamos los datos importantes
      final List<Map<String, dynamic>> images = 
          (value['results'] as List).map((photo) {
        return {
          'id': photo['id'],
          'urls': photo['urls'],
          'user': {
            'name': photo['user']['name'],
            'username': photo['user']['username'],
            'portfolio_url': photo['user']['portfolio_url'],
          },
          'alt_description': photo['alt_description'] ?? 'Imagen de $word',
        };
      }).toList();

      //loger.d('Imágenes encontradas: ${images.length}');
      return value;
      //return value;
    }catch(e){
      /* return {
        "urls": {
        "raw": "...",
        "regular": "...",
        "small": "..."
      }
      } */
     throw Exception("error en pagina 1 $e");
    }
  }
  Future<void> _updSenten(int id) async {
    final sentence = _creado.text.trim();
    if (sentence.isEmpty) return;

    PfIng? currentWord;
    try {
      currentWord = _words.firstWhere((w) => w.id == id);
    } catch (_) {
      currentWord =null;
      return; // No encontró nada, salimos de la función
    }

    final updatedWord = currentWord.copyWith(
      sentence: sentence,
      updatedAt: DateTime.now().toIso8601String(),
    );
    await DatabaseService().updatePfIng(updatedWord);
    _creado.clear();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_next),
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
            const Text('Palabra en inglés que no entiendes'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Escribe la palabra',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveWord,
              child: const Text('Guardar Palabra'),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
            
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pagina2(words: _words)),
                );
              },
              child: const Text('Ir a la segunda página'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_words[index].word),
                    subtitle: Text(_words[index].sentence),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _creado.text = '';
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Editar Sentence"),
                                  content: TextField(
                                    controller: _creado,
                                    decoration: const InputDecoration(
                                      labelText: "Nueva sentence",
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _updSenten(_words[index].id!);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Actualizar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _words[index].sentence));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Texto copiado al portapeles")),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseService().deletePfIng(_words[index].id!);
                            _loadWords();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}