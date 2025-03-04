import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EnglishFlashCard extends StatefulWidget {
  //propiedades para personalizar el widget
  final String word;
  final String definition;
  final String exampleSentence;
  final String imageUrl;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final bool showFrontByDefault;
  const EnglishFlashCard({
    Key? key,
    required this.word,
    required this.definition,
    required this.exampleSentence,
    required this.imageUrl,
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
  FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    _showFront = widget.showFrontByDefault;
  }

  @override
  void activate() {
    super.activate();
  }

  Future<void> Speak(String text) async {
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
    return Container(
      key: const ValueKey<String>('front'),
      height: 350,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //imagen de la palabra
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.imageUrl,
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
            widget.word,
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
          )
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Container(
      key: const ValueKey<String>('back'),
      height: 350,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            onPressed: () => Speak("aun no esta recibiendo audio"),
          ),
        ]),

        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Text(
              widget.definition,
              style: TextStyle(
                fontSize: 16,
                color: widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => Speak("sin texto aun"),
            icon: const Icon(Icons.volume_up),
          ),
        ]),

        const SizedBox(height: 20),
        //ejemplo
        Text(
          'Example:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '"${widget.exampleSentence}"',
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
