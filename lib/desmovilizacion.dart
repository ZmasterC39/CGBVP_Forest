import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesmovilizacionPage extends StatefulWidget {
  final String incidentId;

  DesmovilizacionPage({required this.incidentId});

  @override
  _DesmovilizacionPageState createState() => _DesmovilizacionPageState();
}

class _DesmovilizacionPageState extends State<DesmovilizacionPage> {
  // Campos nuevos
  late DateTime _fechaHora; // Fecha y hora preestablecida
  String _selectedPotencialCrecimiento = 'Nulo';
  String _selectedEstadoIncidente = 'Activo';
  List<String> _selectedIncidentesRegistrados = [];
  String _otherIncidente = '';

  // Opciones para los campos
  final List<String> potencialCrecimientoOptions = [
    'Nulo',
    'Bajo',
    'Moderado',
    'Alto',
    'Muy alto',
  ];

  final List<String> estadoIncidenteOptions = [
    'Activo',
    'Controlado',
    'Extinguido',
    'Otro',
  ];

  final List<String> incidentesRegistradosOptions = [
    'Lesiones',
    'Golpe de calor',
    'Deshidratación',
    'Conflictos',
    'Tráfico de radios',
    'Otros',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fechaHora = DateTime.now(); // Fecha y hora preestablecida por el sistema
  }

  Future<void> _saveDesmovilizacion() async {
    try {
      DocumentReference incidentRef =
          _firestore.collection('incidentes').doc(widget.incidentId);

      await incidentRef.update({
        'desmovilizacion': {
          'fechaHora': Timestamp.fromDate(_fechaHora),
          'potencialCrecimiento': _selectedPotencialCrecimiento,
          'estadoIncidenteAlRetirarse': _selectedEstadoIncidente,
          'incidentesRegistrados': _selectedIncidentesRegistrados,
          'otroIncidenteRegistrado': _otherIncidente,
        },
        'fechaFin': Timestamp.fromDate(_fechaHora),
        'estado': 'completo',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Desmovilización guardada correctamente')),
      );

      // Regresar a la página principal
      Navigator.pushNamedAndRemoveUntil(
          context, '/public_user', (route) => false);
    } catch (e) {
      print('Error al guardar desmovilización: $e');
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
            // Fecha y hora (preestablecido, solo mostrar)
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                  'Fecha y hora: ${_fechaHora.toLocal().toString().substring(0, 16)}'),
            ),
            SizedBox(height: 20),

            // Potencial crecimiento en el próximo periodo operacional
            DropdownButtonFormField<String>(
              value: _selectedPotencialCrecimiento,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPotencialCrecimiento = newValue!;
                });
              },
              items: potencialCrecimientoOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                  labelText:
                      'Potencial crecimiento en el próximo periodo operacional'),
            ),
            SizedBox(height: 20),

            // Cuál es el estado del incidente al momento de retirarse
            DropdownButtonFormField<String>(
              value: _selectedEstadoIncidente,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEstadoIncidente = newValue!;
                });
              },
              items: estadoIncidenteOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                  labelText:
                      'Estado del incidente al momento de retirarse'),
            ),
            SizedBox(height: 20),

            // Incidentes registrados durante la operación
            Text(
              'Incidentes registrados durante la operación',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...incidentesRegistradosOptions.map((incidente) {
              if (incidente != 'Otros') {
                return CheckboxListTile(
                  title: Text(incidente),
                  value: _selectedIncidentesRegistrados.contains(incidente),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedIncidentesRegistrados.add(incidente);
                      } else {
                        _selectedIncidentesRegistrados.remove(incidente);
                      }
                    });
                  },
                );
              } else {
                return CheckboxListTile(
                  title: Text('Otros'),
                  value: _selectedIncidentesRegistrados.contains('Otros'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedIncidentesRegistrados.add('Otros');
                      } else {
                        _selectedIncidentesRegistrados.remove('Otros');
                        _otherIncidente = '';
                      }
                    });
                  },
                );
              }
            }).toList(),
            if (_selectedIncidentesRegistrados.contains('Otros'))
              TextFormField(
                decoration: InputDecoration(labelText: 'Especificar otros'),
                onChanged: (value) {
                  _otherIncidente = value;
                },
              ),
            SizedBox(height: 20),

            // Botón para guardar
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
