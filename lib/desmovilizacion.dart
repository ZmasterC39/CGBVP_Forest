import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesmovilizacionPage extends StatefulWidget {
  @override
  _DesmovilizacionPageState createState() => _DesmovilizacionPageState();
}

class _DesmovilizacionPageState extends State<DesmovilizacionPage> {
  String _selectedIncidentStatus = 'Activo'; // Opción predeterminada
  late DateTime _currentDateTime; // Fecha y hora predeterminada

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now(); // Capturar la fecha y hora actual al cargar la página
  }

  Future<void> _saveDesmovilizacion() async {
    try {
      User? user = _auth.currentUser;
      await _firestore.collection('desmovilizacion').add({
        'usuarioId': user?.uid ?? '',
        'fechaHora': _currentDateTime,
        'estadoIncidente': _selectedIncidentStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Desmovilización guardada correctamente')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la desmovilización')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desmovilización'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Fecha y hora de desmovilización: ${_currentDateTime.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedIncidentStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIncidentStatus = newValue!;
                });
              },
              items: <String>[
                'Activo', 'Controlado', 'Extinguido',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Estado del incidente'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDesmovilizacion,
              child: Text('Guardar Desmovilización'),
            ),
          ],
        ),
      ),
    );
  }
}
