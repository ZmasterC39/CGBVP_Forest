import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluacionDesempenoPage extends StatefulWidget {
  final String incidentId;

  EvaluacionDesempenoPage({required this.incidentId});

  @override
  _EvaluacionDesempenoPageState createState() => _EvaluacionDesempenoPageState();
}

class _EvaluacionDesempenoPageState extends State<EvaluacionDesempenoPage> {
  final _nombreController = TextEditingController();
  final _uboController = TextEditingController();

  String _selectedGrade = 'Seccionario';
  String _selectedPosition = 'Combatiente (COIF)';
  String _selectedEvaluacion = 'Satisfactorio';

  final List<String> _grades = [
    'Seccionario',
    'Sub Teniente',
    'Teniente',
    'Capitan',
    'Tnte. Brigadier',
    'Brigadier',
    'Brigadier Mayor',
    'Brigadier General',
  ];

  final List<String> _positions = [
    'Combatiente (COIF)',
    'Jefe de Cuadrilla (JECU)',
    'Comandante de Incidente (CIT5)',
    'Jefe Brigada (JEFB)',
    'Comandante de Incidente (CIT4)',
  ];

  final List<String> _evaluaciones = [
    'Deficiente',
    'Necesita mejorar',
    'Satisfactorio',
    'Superior',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveEvaluacionDesempeno() async {
    try {
      DocumentReference incidentRef = _firestore.collection('incidentes').doc(widget.incidentId);

      // Crear una nueva evaluación de desempeño
      await _firestore.collection('Evaluación de desempeño').add({
        'incidentId': widget.incidentId,
        'nombre': _nombreController.text,
        'grado': _selectedGrade,
        'ubo': int.tryParse(_uboController.text) ?? 0,
        'posicion': _selectedPosition,
        'evaluacion': _selectedEvaluacion,
        'fechaHora': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evaluación de desempeño guardada correctamente')),
      );

      // Preguntar al usuario si desea agregar otra evaluación
      _showContinueDialog();
    } catch (e) {
      print('Error al guardar evaluación de desempeño: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la evaluación de desempeño')),
      );
    }
  }

  void _showContinueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Desea agregar otra evaluación de desempeño?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
                // Regresar a la página anterior o principal
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
                // Limpiar los campos para una nueva entrada
                _nombreController.clear();
                _uboController.clear();
                setState(() {
                  _selectedGrade = 'Seccionario';
                  _selectedPosition = 'Combatiente (COIF)';
                  _selectedEvaluacion = 'Satisfactorio';
                });
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _uboController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluación de Desempeño'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campo: Nombre y apellidos del personal evaluado
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre y apellidos del personal evaluado',
              ),
            ),
            SizedBox(height: 16),
            // Campo: Grado del personal evaluado
            DropdownButtonFormField<String>(
              value: _selectedGrade,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGrade = newValue!;
                });
              },
              items: _grades.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Grado del personal evaluado'),
            ),
            SizedBox(height: 16),
            // Campo: UBO del personal evaluado
            TextFormField(
              controller: _uboController,
              decoration: InputDecoration(
                labelText: 'UBO del personal evaluado',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Campo: Posición
            DropdownButtonFormField<String>(
              value: _selectedPosition,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                });
              },
              items: _positions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Posición'),
            ),
            SizedBox(height: 16),
            // Campo: Evaluación del conocimiento del trabajo, desempeño, actitud, iniciativa, capacidad física y seguridad
            DropdownButtonFormField<String>(
              value: _selectedEvaluacion,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEvaluacion = newValue!;
                });
              },
              items: _evaluaciones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText:
                    'Evaluación del conocimiento del trabajo, desempeño, actitud, iniciativa, capacidad física y seguridad',
              ),
            ),
            SizedBox(height: 20),
            // Botón para guardar
            ElevatedButton(
              onPressed: _saveEvaluacionDesempeno,
              child: Text('Guardar Evaluación'),
            ),
          ],
        ),
      ),
    );
  }
}
