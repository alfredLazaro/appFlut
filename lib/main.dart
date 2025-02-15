import 'package:flutter/material.dart';

import 'screens/pagina2.dart';// importa la pagina 2
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black), // bodyText1 -> bodyMedium
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // headline1 -> displayLarge
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  TextEditingController _controller = TextEditingController(); // Controlador de TextField

  @override
  Widget build(BuildContext context) {
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
