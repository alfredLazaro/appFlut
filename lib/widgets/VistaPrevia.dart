import 'package:flutter/material.dart';

class VistaPrevia extends StatelessWidget {
  final List<Map<String, dynamic>> definiciones;
  final Function(Map<String, dynamic>) onConfirm;
  const VistaPrevia({
    Key? key,
    required this.definiciones,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("previsulaizar definiciones"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: definiciones.length,
              itemBuilder: (context, index) {
                final item = definiciones[index];
                return Card( 
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                        title: Text(item['definicion']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Palabra: ${item['word']}"),
                            Text("Traduccion: ${item['wordTralat'] ?? '---'}"),
                            Text("Ejemplo: ${item['sentence']}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () => onConfirm(item),
                        )));
              }),
        ));
  }
}
