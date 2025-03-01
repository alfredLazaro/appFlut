import 'dart:convert';
import 'package:http/http.dart' as http;

class AssemblyAIService {
    final String apiKey = '57d4ef538f9147e7bfffe39a8a4c5d69';
    final String transcriptUrl = 'https://assembly.ai/wildfires.mp3';

    Future<String?> transcribeAudio(String audioUrl) async {
        try {
            final response = await http.post(
                Uri.parse(transcriptUrl),
                headers: {
                    "Authorization": apiKey,
                    "Content-Type": "application/json",
                },
                body: jsonEncode({"audio_url": audioUrl}),
            );

            if(response.statusCode == 200) {
                final data = jsonDecode(response.body);
                final transcriptId = data["id"];
                return _getTranscriptText(transcriptId);
            } else {
                print("Error en la peticion: ${response.body}");
                return null;
            }
        } catch (e) {
            print("Error al llamar a AssemblyAI: $e");
            return null;
        }
    }

    //Metodo para obtener el texto transcrito
    Future<String?> _getTranscriptText(String transcriptId) async {
        try{
            while (true) {
                final response = await http.get(
                    Uri.parse("$transcriptUrl/$transcriptId"),
                    headers: {"Authorization": apiKey},
                );

                if(response.statusCode == 200) {
                    final data = jsonDecode(response.body);
                    final status = data["status"];

                    if(status == "completed") {
                        return data["text"];
                    } else if (status == "failed"){
                        print("La transcripcion fallo.");
                        return null;
                    }
                }

                await Future.delayed(Duration(seconds: 3)); //Esperar antes de hacer otra peticion
            }
        } catch (e){
            print("Error al obtener la transcripcion: $e");
            return null;
        }
    }
}