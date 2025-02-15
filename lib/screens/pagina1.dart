import 'package:flutter/material.dart';
import 'pagina2.dart'; //importa la pantalla 2

class Pagina1 extends StatelessWidget{
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text('Pagina 1'),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                        //navega a la segunda pagina
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pagina2()),
                        );
                    }
                    child: Text('siguiente Pagina'),
                ),
            )
        );
    }
}