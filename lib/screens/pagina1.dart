import 'dart:io';
import 'package:flutter/material.dart';
import 'pagina2.dart';
import '../services/database_service.dart';
import '../models/pf_ing_model.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart'; // Importa el paquete record
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Para manejar permisos

class Pagina1 extends StatefulWidget {
  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _creado = TextEditingController();
  List<PfIng> _words = [];

  final _recorder = Record(); // Usa el método Record() para obtener una instancia
  String _audioPath = "";
  bool _isRecording = false;
  //final TextEditingController _transcripcion= TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadWords();
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

    PfIng newWord = PfIng(
      definicion: '',
      word: word,
      sentence: "Dame una oracion con el uso '$word' en ingles que contenga mas de 10 palabras y menos de 40 palabras, ademas de resaltar la frase o palabra que te di",
      learn: 0,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    await DatabaseService().insertPfIng(newWord);

    _controller.clear();
    _loadWords();
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
            GestureDetector(
              onLongPress: _startRecording, //al presionar
              onLongPressEnd: (details) => _stopRecording(), //cuando se suelta
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
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