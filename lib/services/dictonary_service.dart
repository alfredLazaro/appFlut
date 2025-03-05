import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordService {
  // Constructor privado para implementar patrón singleton
  static final WordService _instance = WordService._internal();
  factory WordService() => _instance;
  WordService._internal();

  // URL base para la API, obtenida de variables de entorno
  String get baseUrl => dotenv.env['BASE_URL_DICTIONARY'] ?? 'https://api.example.com';

  // Método para obtener definición de palabra
  Future<dynamic> getWordDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$word')
      );

      if (response.statusCode == 200) {
        // Devuelve la respuesta decodificada
        return json.decode(response.body);
      } else {
        throw Exception('Palabra no encontrada');
      }
    } catch (e) {
      throw Exception('Error al buscar la definición');
    }
  }
}

// Ejemplo de clase de proveedor de estado
class WordProvider extends ChangeNotifier {
  String _definition = '';
  String _example = '';
  bool _isLoading = false;
  String _error = '';

  String get definition => _definition;
  String get example => _example;
  bool get isLoading => _isLoading;
  String get error => _error;

  final WordService _wordService = WordService();

  Future<void> fetchWordDefinition(String word) async {
    // Resetear estado
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final result = await _wordService.getWordDefinition(word);
      _definition = result['definition'];
      _example = result['example'];
      _isLoading = false;
    } catch (e) {
      _error = 'No se pudo obtener la definición';
      _isLoading = false;
    }
    
    notifyListeners();
  }
}