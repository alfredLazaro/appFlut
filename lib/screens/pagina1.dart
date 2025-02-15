import 'package:flutter/material.dart';
import 'pagina2.dart'; //importa la pantalla 2

class Pagina1 extends StatelessWidget{
    TextEditingController _controller = TextEditingController(); // Controlador de TextField

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