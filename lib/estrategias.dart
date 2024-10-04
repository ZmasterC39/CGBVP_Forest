import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/desmovilizacion.dart';
import 'identificar_recursos.dart';

class EstrategiasPage extends StatefulWidget {
  final String incidentId;

  EstrategiasPage({required this.incidentId});

  @override
  _EstrategiasPageState createState() => _EstrategiasPageState();
}

class _EstrategiasPageState extends State<EstrategiasPage> {
  String _selectedStrategy = 'Ataque directo';
  List<String> _selectedTactics = [];
  String _otherTactic = '';
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Asignar la hora actual al inicio
  }

  Future<void> _saveEstrategias() async {
    try {
      DocumentReference incidentRef =
          _firestore.collection('incidentes').doc(widget.incidentId);

      await incidentRef.update({
        'estrategias': {
          // ... tus campos de estrategias
          'horaInicio': _startTime,
          'estrategia': _selectedStrategy,
          'tacticas': _selectedTactics,
          'otraTactica': _otherTactic,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estrategias guardadas correctamente')),
      );

      // Preguntar si desea continuar
      _showContinueDialog(widget.incidentId);
    } catch (e) {
      // Manejo de errores
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar las estrategias')),
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
              Navigator.pop(context); // Cerrar el diálogo
              // Regresar a la página principal
              Navigator.pushNamedAndRemoveUntil(
                  context, '/public_user', (route) => false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
              // Navegar a la siguiente página
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DesmovilizacionPage(incidentId: widget.incidentId),
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
        title: Text('Determinar Estrategias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Hora de inicio: ${_startTime.toLocal()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedStrategy,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStrategy = newValue!;
                  });
                },
                items: <String>[
                  'Ataque directo',
                  'Ataque indirecto',
                  'Ataque indirecto paralelo',
                  'Liquidación',
                  'Esperar ventanas, zonas de oportunidad',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration:
                    InputDecoration(labelText: 'Asignación de Estrategia'),
              ),
              SizedBox(height: 20),
              Text(
                'Asignación de Tácticas',
                style: TextStyle(fontSize: 16),
              ),
              CheckboxListTile(
                title: Text('Batefuegos'),
                value: _selectedTactics.contains('Batefuegos'),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedTactics.add('Batefuegos');
                    } else {
                      _selectedTactics.remove('Batefuegos');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Línea de agua'),
                value: _selectedTactics.contains('Línea de agua'),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedTactics.add('Línea de agua');
                    } else {
                      _selectedTactics.remove('Línea de agua');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Sofocación'),
                value: _selectedTactics.contains('Sofocación'),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedTactics.add('Sofocación');
                    } else {
                      _selectedTactics.remove('Sofocación');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Línea de control'),
                value: _selectedTactics.contains('Línea de control'),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedTactics.add('Línea de control');
                    } else {
                      _selectedTactics.remove('Línea de control');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Reubicación de equipos'),
                value: _selectedTactics.contains('Reubicación de equipos'),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedTactics.add('Reubicación de equipos');
                    } else {
                      _selectedTactics.remove('Reubicación de equipos');
                    }
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Otros (ingresa manualmente)'),
                onChanged: (value) {
                  _otherTactic = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEstrategias,
                child: Text('Guardar Estrategias'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
