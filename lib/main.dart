import 'package:first_app/services/deep_ai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/pagina1.dart';
import 'screens/pagina2.dart';// importa la pagina 2
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load(fileName: "assets/.env"); //Cargar variables de entorno
  //sqfliteFfinit();
  await DeepSeekApiService().initialize(); // Inicializa el servicio de API
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pagina1(),//pantalla de inicio
    );
  }
}
