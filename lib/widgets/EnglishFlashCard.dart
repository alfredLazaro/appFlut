
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:first_app/models/pf_ing_model.dart';
class EnglishFlashCard extends StatefulWidget {
  //propiedades para personalizar el widget
  final PfIng wordData;
  final String word;
  final String imageUrl;
  final int learn;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final bool showFrontByDefault;
  final VoidCallback onLearned;
  final VoidCallback resetLearn;
  final Function(String) testingWord;
  const EnglishFlashCard({
    Key? key,
    required this.wordData,
    required this.word,
    required this.imageUrl,
    required this.learn,
    required this.onLearned,
    required this.resetLearn,
    required this.testingWord,
    this.cardColor = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius = 15.0,
    this.showFrontByDefault = true,
  }) : super(key: key);

  @override
  State<EnglishFlashCard> createState() => _EnglishFlasCardState();
}

class _EnglishFlasCardState extends State<EnglishFlashCard> {
  late bool _showFront;
  late PfIng _word;
  FlutterTts flutterTts = FlutterTts();
  late final TextEditingController _wordTest;
  @override
  void initState() {
    super.initState();
    _showFront = widget.showFrontByDefault;
    _word = widget.wordData;
    _wordTest= TextEditingController();
  }

  Future<void> speakf(String text) async {
    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
    } catch (e) {
      print('Error al leer el texto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFront = !_showFront;
        });
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        color: widget.cardColor,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _showFront ? _buildFrontSide() : _buildBackSide(),
        ),
      ),
    );
  }

  Widget _buildFrontSide() {
    //textNoWord="word not found";
    return Container(
      key: const ValueKey<String>('front'),
      height: 450,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //imagen de la palabra
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              _word.imageUrl ?? "ruta/defect.png",// no esta definido en el modelo
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          //Palabra en ingles
          Text(
            _word.word.isNotEmpty == true ? _word.word : 'Word not found',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          //Instruccion para voltear
          Text(
            'Tap to see definition',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: widget.textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 15),
          //botones de control
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  widget.onLearned(); //llamo funcion incremento en pagina 2
                },
                icon: const Icon(Icons.check),
                label: const Text('Learned'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  widget.resetLearn(); //llamo la funcion reset en pagina 2
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text("Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          )
            
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Container(
      key: const ValueKey<String>('back'),
      height: 450,
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //test
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Expanded(
              child: TextField(
              controller: _wordTest,
              decoration: const InputDecoration(
                labelText: 'Aprendiste?',
                border: OutlineInputBorder(),
              ),
            ),
            ),
            ElevatedButton(
              onPressed: (){
                widget.testingWord(_wordTest.text);
              },
              child: const Icon(Icons.send)
            ),
          ]
        ),
        //definicion
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Text(
              'Definition:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => speakf(_word.definicion ),
          ),
        ]),

        const SizedBox(height: 3),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Text(
              _word.definicion,
              style: TextStyle(
                fontSize: 16,
                color: widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
        ]),

        const SizedBox(height: 10),
        //ejemplo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: 
                Text(
                  'Example:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => speakf(_word.sentence),
              icon: const Icon(Icons.volume_up),
            ),
          ]
        ),
        const SizedBox(height: 8),
        Text(
          '"${_word.sentence}"',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: widget.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Instruccion para voltear
        Text(
          'Tap to see word again',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: widget.textColor.withOpacity(0.6),
          ),
        ),
      ]),
    );
  }
}
