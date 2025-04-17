import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
class ImageService{
  static final ImageService _instance= ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal() {
    _init();
  }
  String? _apiKey;
  String? _basUrl;
  late Dio _dio;
  Future<void> _init() async{
    await dotenv.load(fileName: '.env');
    _apiKey =dotenv.env['KEY_UNS'];
    _basUrl = dotenv.env['URL_UNS'];
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception("🔴 API_KEY no encontrada en .env");
    }

    if (_basUrl == null || _basUrl!.isEmpty) {
      throw Exception("🔴 API_BASE_URL no encontrada en .env");
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: _basUrl!,
        connectTimeout: const Duration(seconds: 5), // Tiempo máximo de conexión
        receiveTimeout: const Duration(seconds: 3), // Tiempo máximo de respuesta
      ),
    );
  }

  Future<Map<String, dynamic>> getImg(String namImg) async{
    try{
      final response = await _dio.get(
        '/search/photos',
        queryParameters: {
          'query': namImg
        },
        options: Options(headers:{
          'Authorization': 'Client-ID $_apiKey'
        })
      );
      return response.data as Map<String,dynamic>;
    }on DioException catch (e){
      if (e.response != null) {
        throw Exception("Error ${e.response?.statusCode}: ${e.response?.data}");
      } else {
        throw Exception("Error de conexión: ${e.message}");
      }
    }
  }
}