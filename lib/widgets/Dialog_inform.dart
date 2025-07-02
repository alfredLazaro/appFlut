import 'package:flutter/material.dart';
class DefinitionSelector extends StatefulWidget {
  final List<Map<String, dynamic>> meanings;
  
  const DefinitionSelector({Key? key, required this.meanings}) : super(key: key);

  @override
  _DefinitionSelectorState createState() => _DefinitionSelectorState();
}

class _DefinitionSelectorState extends State<DefinitionSelector> {
  int _selectedMeaningIndex = 0;
  int? _selectedDefinitionIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.meanings.isEmpty) {
      return const Center(child: Text('No hay definiciones disponibles'));
    }

    final selectedMeaning = widget.meanings[_selectedMeaningIndex];
    final definitions = selectedMeaning['definitions'] as List<dynamic>;
    final partOfSpeech = selectedMeaning['partOfSpeech'] as String;

    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Seleccionar Definición',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              
              // Selector de Part of Speech
              DropdownButtonFormField<int>(
                value: _selectedMeaningIndex,
                decoration: InputDecoration(
                  labelText: 'Categoría Gramatical',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(widget.meanings.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(widget.meanings[index]['partOfSpeech']),
                  );
                }),
                onChanged: (int? newIndex) {
                  setState(() {
                    _selectedMeaningIndex = newIndex!;
                    _selectedDefinitionIndex = null;
                  });
                },
              ),

              SizedBox(height: 20),

              // Lista de definiciones con tamaño fijo
              Text(
                'Definiciones:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: definitions.length,
                  itemBuilder: (context, index) {
                    final definition = definitions[index] as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: _selectedDefinitionIndex == index
                          ? Colors.blue[50]
                          : null,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDefinitionIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ${definition['definition']}',
                                style: TextStyle(fontSize: 14),
                              ),
                              if (definition['example'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Ejemplo: ${definition['example']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectedDefinitionIndex != null
                        ? () {
                            final selectedDef = definitions[_selectedDefinitionIndex!];
                            Navigator.pop(context, {
                              'partOfSpeech': partOfSpeech,
                              'definition': selectedDef['definition'],
                              'example': selectedDef['example'],
                              'synonyms': selectedDef['synonyms'] ?? [], // Lista de sinónimos
                              'antonyms': selectedDef['antonyms'] ?? [],
                            });
                          }
                        : null,
                    child: Text('siguiente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}