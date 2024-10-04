import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesmovilizacionPage extends StatefulWidget {
  final String incidentId;

  DesmovilizacionPage({required this.incidentId});

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
      // Obtener la referencia al documento del incidente usando widget.incidentId
      DocumentReference incidentRef =
          _firestore.collection('incidentes').doc(widget.incidentId);

      // Actualizar el documento con los datos de desmovilización
      await incidentRef.update({
        'desmovilizacion': {
          'fechaHora': _currentDateTime,
          'estadoIncidente': _selectedIncidentStatus,
        },
        'fechaFin': Timestamp.now(), // Puedes agregar una fecha de finalización
        'estado': 'completo',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Desmovilización guardada correctamente')),
      );

      // Regresar a la página principal
      Navigator.pushNamedAndRemoveUntil(context, '/public_user', (route) => false);
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