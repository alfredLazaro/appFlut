import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeepSeekApiService {
  static late final String _apiKey; // Nunca la subas a GitHub
  static late String _apiUrl;
//https://api.deepseek.com/v1/chat/completions
  // Método para enviar un mensaje y recibir respuesta
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    _apiKey = dotenv.env['API_DEE'] ?? '';
    _apiUrl = dotenv.env['URL_D'] ?? '';
  }
  Future<String> getChatResponse(String userMessage) async {
    if (_apiKey.isEmpty) {
      await initialize();
    }
    //imprimir la url
    print(_apiUrl);
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch response: $e');
    }
  }
}