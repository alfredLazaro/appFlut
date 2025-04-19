import 'package:first_app/services/dictonary_service.dart';
import 'package:first_app/widgets/EditDialog.dart';
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
  final TextEditingController _captWord = TextEditingController();
  //hablar a texto
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<PfIng> _words = [];
  final WordService _wordService = WordService();

  //api para imagenes
  final apiImg=ImageService();
  //paginacion 
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Método para calcular el número de páginas
  int get _pageCount => (_words.length / 3).ceil();

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
            _captWord.text = val.recognizedWords; //
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
    String word = _captWord.text;
    if (word.isEmpty) return;
    
    final data = await obtenerDatos(word);
    final imgagen= await getImages(word);
    final priImg= imgagen[0];
    PfIng newWord = PfIng(
      definicion: data['definition'] ?? 'no hay definicion',
      word: word,
      sentence: data['example'] ?? '',
      learn: 0,
      imageUrl: priImg['url']['regular'],
      context: "",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    await DatabaseService().insertPfIng(newWord);
    _captWord.clear();
    _loadWords();

  }

  Future<Map<String,dynamic>> obtenerDatos(String word) async {
    try{
      final value = await _wordService.getWordDefinition(word);
      loger.d("...............servicio diccionario..............");
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

  Future<List<Map<String,dynamic>>> getImages(String word) async{
    try{
      final value= await apiImg.getMinImg(word);
      loger.d(value[0]);
      return value;
    }catch(e){
      loger.d("pagina 1, image not found $e");
      return [
        {
          'url':{
            'regular':'assets/img_defecto.jpg',
            'small':'assets/img_defecto.jpg',
          }
        }
      ];
    }
  }
  Future<void> _updSenten(int id,String newSentence) async {
    final sentence = newSentence.trim();
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
    _loadWords();
  }
  void _editSentenceNew(PfIng word) {
    showDialog(
      context: context,
      builder: (context) => EditSentenceDialog(
        initialSentence: word.sentence,
        onUpdate: (newSentence) async {
          await _updSenten(word.id!,newSentence);
          _loadWords(); // Recargar las palabras después de editar
        },
      ),
    );
  }
  Future<void> _deleteWord(int id) async {
    await DatabaseService().deletePfIng(id);
    _loadWords(); // Recargar las palabras después de eliminar
    // Ajustar la página si es necesario
    if (_currentPage >= _pageCount && _pageCount > 0) {
      setState(() {
        _currentPage = _pageCount - 1;
      });
    }
  }
  void _copySentence(String sentence) {
    Clipboard.setData(ClipboardData(text: sentence));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Texto copiado al portapeles")),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprendiendo'),
        actions: [
          ElevatedButton(
            child: const Icon(Icons.navigate_next),
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
            const Text('Palabra a aprender'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _captWord,
                decoration: InputDecoration(
                  labelText: 'Escribe la palabra',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: _listen, 
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveWord,
              child: const Text('Guardar'),
            ),
            
            const SizedBox(height: 10),
            // Widget modificado
            Expanded(
              child: Column(
                children: [
                  // Mostrar solo 3 elementos
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pageCount,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * 3;
                        final endIndex = (startIndex + 3).clamp(0, _words.length);
                        final displayedWords = _words.sublist(startIndex, endIndex);
                        
                        return ListView.builder(
                          itemCount: displayedWords.length,
                          itemBuilder: (context, index) {
                            final word = displayedWords[index];
                            return ListTile(
                              title: Text(word.word),
                              subtitle: Text(word.sentence),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editSentenceNew(word),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () => _copySentence(word.sentence),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteWord(word.id!),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  
                  // Controles de paginación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPage > 0 
                            ? () => _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                )
                            : null,
                      ),
                      Text('Página ${_currentPage + 1} de $_pageCount'),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPage < _pageCount - 1
                            ? () => _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}