import 'package:flutter/material.dart';
import 'pagina2.dart'; //importa la pantalla 2
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Pagina1 extends StatelessWidget{
    TextEditingController _controller = TextEditingController(); // Controlador de TextField
    String transcription = "";
    Future<String> fetchLlamaResponse(String prompt) async {
      final url = Uri.parse('URL_LLAM');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ',
      };
      final body = jsonEncode({
        'prompt': prompt,
        'max_tokens': 50,
      });

      final response = await http.post(url, headers: headers, body: body);

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['text']; // ajusta segun la estructura de la respuesta
      } else {
        throw Exception('Failed to load response from LLaMA API');
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
                String response = await fetchLlamaResponse("Hola, ¿como estas?");
                print(response);
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