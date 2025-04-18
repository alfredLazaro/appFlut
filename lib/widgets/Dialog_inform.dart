import 'package:flutter/material.dart';
class DialogInform extends StatefulWidget{
  final List<Map<String,dynamic>> meanings;
  DialogInform({
    Key? key,
    required this.meanings,
  }):super(key: key);
  @override
  State<DialogInform> createState()=> _DialogInformState();
}
class _DialogInformState extends State<DialogInform>{
  int _currentMeaningIndex = 0;
  int _currentDefinitionIndex = 0;
  int _currentSynonymIndex = 0;
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if (widget.meanings.isEmpty) {
      return const Center(child: Text('No se encontraron significados'));
    }

    final currentMeaning = widget.meanings[_currentMeaningIndex];
    final definitions = (currentMeaning['definitions'] as List).cast<Map<String, dynamic>>();
    final currentDefinition = definitions[_currentDefinitionIndex];
    final synonyms = (currentMeaning['synonyms'] as List).cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector de Meaning (partOfSpeech)
        _buildSelector(
          label: 'Significado',
          count: widget.meanings.length,
          currentIndex: _currentMeaningIndex,
          onChanged: (index) {
            setState(() {
              _currentMeaningIndex = index;
              _currentDefinitionIndex = 0;
              _currentSynonymIndex = 0;
            });
          },
          itemBuilder: (index) => Text(
            '${index + 1}. ${widget.meanings[index]['partOfSpeech']}',
          ),
        ),

        const SizedBox(height: 16),

        // Definición actual
        Text(
          'Definición:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          currentDefinition['definition'] ?? 'Sin definición',
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        // Ejemplo si existe
        if (currentDefinition['example'] != null) ...[
          const SizedBox(height: 12),
          Text(
            'Ejemplo:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '"${currentDefinition['example']}"',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],

        const SizedBox(height: 16),

        // Selector de Definiciones
        if (definitions.length > 1)
          _buildSelector(
            label: 'Definición',
            count: definitions.length,
            currentIndex: _currentDefinitionIndex,
            onChanged: (index) {
              setState(() {
                _currentDefinitionIndex = index;
              });
            },
            itemBuilder: (index) => Text('Definición ${index + 1}'),
          ),

        const SizedBox(height: 16),

        // Sinónimos si existen
        if (synonyms.isNotEmpty) ...[
          Text(
            'Sinónimos:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildSelector(
            label: 'Sinónimo',
            count: synonyms.length,
            currentIndex: _currentSynonymIndex,
            onChanged: (index) {
              setState(() {
                _currentSynonymIndex = index;
              });
            },
            itemBuilder: (index) => Text(synonyms[index]),
          ),
        ],

        // Antónimos si existen
        if ((currentMeaning['antonyms'] as List).isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Antónimos:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: (currentMeaning['antonyms'] as List)
                .cast<String>()
                .map((antonym) => Chip(label: Text(antonym)))
                .toList(),
          ),
        ],
      ],
    );
  }

  //
  Widget _buildSelector({
    required String label,
    required int count,
    required int currentIndex,
    required ValueChanged<int> onChanged,
    required Widget Function(int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(count, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: itemBuilder(index),
                  selected: currentIndex == index,
                  onSelected: (selected) {
                    if (selected) {
                      onChanged(index);
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}