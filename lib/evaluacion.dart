import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'estrategias.dart';

class EvaluacionPage extends StatefulWidget {
  @override
  _EvaluacionPageState createState() => _EvaluacionPageState();
}

class _EvaluacionPageState extends State<EvaluacionPage> {
  final _bomberoCodeController = TextEditingController();
  final _sectorController = TextEditingController();
  final _tamanoController = TextEditingController();
  final _otherFuelTypeController = TextEditingController(); // Controlador para el campo "Otros" de tipo de combustible
  final _otherRiskValueController = TextEditingController(); // Controlador para el campo "Otros" de valores de riesgo

  String _selectedFuelType = 'Pastizales';
  String _selectedSlope = 'Plana o ligeramente inclinada (0-5%)';
  String _selectedFlameLength = 'Baja (hasta 1)';
  String _selectedRiskValue = 'Viviendas';
  
  bool _isOtherFuelTypeSelected = false; // Para rastrear si se selecciona "Otros" en tipo de combustible
  bool _isOtherRiskValueSelected = false; // Para rastrear si se selecciona "Otros" en valores de riesgo

  String? _latitude;
  String? _longitude;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Obtener la ubicación del usuario al cargar la pantalla
  }

  // Obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de ubicación denegado')),
      );
    }
  }

  Future<void> _saveEvaluation() async {
    try {
      User? user = _auth.currentUser;

      // Crear el documento del incidente y obtener el incidentId
      DocumentReference incidentRef = await _firestore.collection('incidentes').add({
        'usuarioId': user?.uid ?? '',
        'fechaInicio': Timestamp.now(),
        'estado': 'incompleto', // Agregar campo de estado
      });

      String incidentId = incidentRef.id;

      // Obtener el tipo de combustible seleccionado o personalizado
      String fuelType = _isOtherFuelTypeSelected
          ? _otherFuelTypeController.text
          : _selectedFuelType;

      // Obtener el valor de riesgo seleccionado o personalizado
      String riskValue = _isOtherRiskValueSelected
          ? _otherRiskValueController.text
          : _selectedRiskValue;

      // Guardar la evaluación inicial como campo en el documento
      await incidentRef.update({
        'evaluacionInicial': {
          'codigoBomberos': _bomberoCodeController.text,
          'fuerzaTareaPRIF': user?.uid ?? '', // O como lo obtengas
          'fechaHora': Timestamp.now(),
          'coordenadas': {
            'latitud': _latitude,
            'longitud': _longitude,
          },
          'ubicacionGeografica': _sectorController.text,
          'tipoCombustible': fuelType,
          'tamanoHectareas': _tamanoController.text,
          'pendiente': _selectedSlope,
          'longitudLlama': _selectedFlameLength,
          'valoresRiesgo': riskValue,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evaluación guardada correctamente')),
      );

      _showContinueDialog(incidentId);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la evaluación')),
      );
    }
  }

  void _showContinueDialog(String incidentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Deseas continuar al siguiente paso?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/public_user', (route) => false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstrategiasPage(incidentId: incidentId),
                ),
              );
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluación Inicial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _bomberoCodeController,
              decoration: InputDecoration(labelText: 'Código Bomberos (6 dígitos)'),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: _sectorController,
              decoration: InputDecoration(labelText: 'Nombre del Sector/Caserío/Poblado'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            Text(
              'Latitud: ${_latitude ?? "Obteniendo..."}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Longitud: ${_longitude ?? "Obteniendo..."}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedFuelType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFuelType = newValue!;
                  _isOtherFuelTypeSelected = newValue == 'Otros'; // Comprobar si se selecciona "Otros"
                });
              },
              items: <String>[
                'Pastizales', 'Pastizal-matorral', 'Matorral', 'Sotobosque', 'Hojarasca', 
                'Restos de tala-material arranxado', 'Otros'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Tipo de Combustible'),
            ),
            // Mostrar el campo de texto si se selecciona "Otros"
            if (_isOtherFuelTypeSelected)
              TextFormField(
                controller: _otherFuelTypeController,
                decoration: InputDecoration(labelText: 'Especifique el tipo de combustible'),
                keyboardType: TextInputType.text,
              ),
            TextFormField(
              controller: _tamanoController,
              decoration: InputDecoration(labelText: 'Tamaño estimado (Hectáreas)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedSlope,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSlope = newValue!;
                });
              },
              items: <String>[
                'Plana o ligeramente inclinada (0-5%)', 'Moderadamente inclinada (5-15%)', 
                'Fuertemente inclinada (15-30%)', 'Empinada (30-50%)', 'Muy empinada (mayor a 50%)'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Pendiente'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedFlameLength,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFlameLength = newValue!;
                });
              },
              items: <String>[
                'Baja (hasta 1)', 'Media (1.5-2,5)', 'Alta (2,5-3,5)', 'Muy alta (3,5)'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Longitud de la Llama'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedRiskValue,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRiskValue = newValue!;
                  _isOtherRiskValueSelected = newValue == 'Otros'; // Comprobar si se selecciona "Otros"
                });
              },
              items: <String>[
                'Viviendas', 'Especies protegidas', 'Cuencas de agua', 'Patrimonio cultural', 'Otros'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Valores expuestos al riesgo'),
            ),
            // Mostrar el campo de texto si se selecciona "Otros" en valores de riesgo
            if (_isOtherRiskValueSelected)
              TextFormField(
                controller: _otherRiskValueController,
                decoration: InputDecoration(labelText: 'Especifique el valor expuesto al riesgo'),
                keyboardType: TextInputType.text,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEvaluation,
              child: Text('Guardar Evaluación'),
            ),
          ],
        ),
      ),
    );
  }
}
