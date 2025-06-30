import 'package:flutter/material.dart';
import 'Dialog_inform.dart';
import 'Dialog_Image.dart';
class WordCreationDialog extends StatefulWidget {
  final List<Map<String, dynamic>> meanings;
  final List<String> imageUrls;
  final String word;

  const WordCreationDialog({
    Key? key,
    required this.meanings,
    required this.imageUrls,
    required this.word,
  }) : super(key: key);

  @override
  _WordCreationDialogState createState() => _WordCreationDialogState();
}

class _WordCreationDialogState extends State<WordCreationDialog> {
  int _currentStep = 0;
  Map<String, dynamic>? _selectedDefinition;
  List<String> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _goToNextStep,
          onStepCancel: _goToPreviousStep,
          controlsBuilder: _buildControls,
          steps: [
            // Paso 1: Selección de definición
            Step(
              title: const Text('Definición'),
              content: DefinitionSelector(
                meanings: widget.meanings,
                onDefinitionSelected: (definition) {
                  setState(() => _selectedDefinition = definition);
                },
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 
                  ? StepState.complete 
                  : StepState.indexed,
            ),
            
            // Paso 2: Selección de imágenes
            Step(
              title: const Text('Imágenes'),
              content: ImageSelectorDialog(
                imageUrls: widget.imageUrls,
                onImagesSelected: (images) {
                  setState(() => _selectedImages = images);
                },
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 
                  ? StepState.complete 
                  : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentStep != 0)
            TextButton(
              onPressed: details.onStepCancel,
              child: const Text('Atrás'),
            ),
          const SizedBox(width: 8),
          if (_currentStep < 1)
            ElevatedButton(
              onPressed: _selectedDefinition != null 
                  ? details.onStepContinue 
                  : null,
              child: const Text('Siguiente'),
            ),
          if (_currentStep == 1)
            ElevatedButton(
              onPressed: () => _saveAndClose(context),
              child: const Text('Guardar'),
            ),
        ],
      ),
    );
  }
  void _goToNextStep() {
    if (_currentStep < 1) {
      setState(() => _currentStep += 1);
    }
  }
  
}