import 'dart:io';
import 'package:first_app/services/dictonary_service.dart';
import 'package:flutter/material.dart';
import 'pagina2.dart';
import '../services/database_service.dart';
import '../models/pf_ing_model.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart'; // Importa el paquete record
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Para manejar permisos
import 'package:speech_to_text/speech_to_text.dart' as stt; // Para el reconocimiento de voz

class Pagina1 extends StatefulWidget {
  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _creado = TextEditingController();
  //hablar a texto
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<PfIng> _words = [];
  WordService _wordService = WordService();
  final _recorder = Record(); // Usa el método Record() para obtener una instancia
  String _audioPath = "";
  bool _isRecording = false;
  //final TextEditingController _transcripcion= TextEditingController();

  //uso appi deep 
  //final DeepSeekApiService _deepSeekApiService = DeepSeekApiService();
 /*  String _responseD = "";
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    setState(() => _isLoading = true);
    try {
      final response = await DeepSeekApiService().getChatResponse(message);
      setState(() {
        _responseD = response;
        print("1111111111111111111111111111111111111111111111111111111111111111111111");
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("asdfa-00000000000000000000000000000000000000000000000000000000000000000000000000");
      print("Error: $e");
    }finally {
      setState(() => _isLoading = false);
    }
  } */

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
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
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

  Future<void> _checkPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      // Permiso concedido
    } else {
      print("Permiso de micrófono denegado");
    }
  }

  Future<void> _startRecording() async {
    await _checkPermissions(); // Verifica los permisos
    try {
      if (await _recorder.hasPermission()) {
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/recorded_audio.mp3';

        await _recorder.start(
          path: filePath,
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );

        setState(() {
          _audioPath = filePath;
        });
        setState(()=> _isRecording = true);
      } else {
        print("No tienes permisos para grabar audio.");
      }
    } catch (e) {
      print("Error al iniciar la grabación: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
      });
      if(path != null){
        setState(() {
          _audioPath = path;
        });
        print("Audio guardado en: $_audioPath");
      }else{
        print("se detuvo por que path es null.");
      }
      /* String? transcrit = await _assemblyServ.transcribeAudio(_audioPath);
      setState(() {
        _controller.text = transcrit!;
      }); */
    } catch (e) {
      print("Error al detener la grabación: $e");
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
    PfIng newWord = PfIng(
      definicion: data['definition'] ?? 'no hay definicion',
      word: word,
      sentence: data['example'] ?? 'no hay ejemplo',
      learn: 0,
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
      print(".....................servicio diccionario......................................");
      print(value);
      return value;
    }catch(e){
      print("Error al obtener datos: $e");
      return {
        'definition': 'No se encontró la definición',
        'example': 'No se encontró el ejemplo'
      };
    }
  }

  Future<void> _updSenten(int id) async {
    String sentence = _creado.text;
    if (sentence.isEmpty) return;

    PfIng? currentWrd = _words.firstWhere(
      (word) => word.id == id,
      orElse: () => PfIng(
        id: id,
        definicion: '',
        word: '',
        sentence: '',
        learn: 0,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );

    if (currentWrd.word.isEmpty) return;

    PfIng newWord = PfIng(
      id: id,
      definicion: currentWrd.definicion,
      word: currentWrd.word,
      sentence: sentence,
      learn: currentWrd.learn,
      createdAt: currentWrd.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    await DatabaseService().updatePfIng(newWord);

    _creado.clear();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Principal'),
        actions: [
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
              onPressed: _saveWord,
              child: Text('Guardar Palabra'),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
            
            SizedBox(height: 10),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _creado.text = '';
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Editar Sentence"),
                                  content: TextField(
                                    controller: _creado,
                                    decoration: InputDecoration(
                                      labelText: "Nueva sentence",
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _updSenten(_words[index].id!);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Actualizar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _words[index].sentence));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Texto copiado al portapeles")),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}