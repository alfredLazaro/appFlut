import 'package:flutter/material.dart';
import 'pagina2.dart'; //importa la pantalla 2
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Pagina1 extends StatelessWidget{
    TextEditingController _controller = TextEditingController(); // Controlador de TextField
    String transcription = "";
    Future<void> transcribeAudio(String audioUrl) async {
      final String apiKey = dotenv.get('ASSEMBLYAI_API_KEY');
      final String uploadUrl = 'http://api.assemblyai.com/v2/upload';
      final String transcriptUrl = 'https://api.assemblyai.com/v2/transcript';

      //subir el archivo de audio 
      final uploadResponse = await http.post(
        Uri.parse(uploadUrl),
        headers: {
          'authorization':apiKey,
        },
        body: await http.readBytes(Uri.parse(audioUrl)),
      );
      
      if(uploadResponse.statusCode == 200){
        final uploadData = jsonDecode(uploadResponse.body);
        final String audioUrl = uploadData['upload_url'];

        // Solicitar la transcription
        final transcriptResponse = await http.post(
          Uri.parse(transcriptUrl),
          headers: {
            'authorization': apiKey,
            'content-type' : 'application/json',
          },
          body: jsonEncode({
            'audio_url': audioUrl,
          }),
        );

        if(transcriptResponse.statusCode == 200){
          final transcriptData = jsonDecode(transcriptResponse.body);
          final String transcriptId = transcriptData['id'];

          // Obtener la transcription completada
          while (true){
            final statusResponse = await http.get(
              Uri.parse('$transcriptUrl/$transcriptId'),
              headers: {
                'authorization': apiKey,
              },
            );

            final statusData = jsonDecode(statusResponse.body);
            if (statusData['status']== 'completed'){
              setState(() {
                trasncription = statusData['text'];
              });
              break;
            } else if(statusData['status']=='error'){
              setState((){
                transcription = 'Error al transcribir el audio';
              });
              break;
            }
            await Future.delayed(Duration(seconds: 2));
          }
        }else{
          setState(() {
            transcription = 'Error al solicitar la transcription';
          });
        }
      }else {
        setState( () {
          transcription = 'Error al subir el archivo de audio';
        });
      }
    }
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
        title: Text('Página Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('Palabra en ingles que no entiendes'),
            TextField(
              controller: _controller, //Asociamos el controlador al Textfield
              decoration: InputDecoration(
                labelText: 'Escribe la palabra',
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('texto ingresado: ${_controller.text}'); //Obtiene el texto y lo imprime
              },
              child: Text('Presioname'),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:19),

            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>Pagina2()),
                );
                print('Boton sig Pagina');
              },
              child: Text('sig pagina'),
            ),
          ],

        ),
      ),
        );
    }
}