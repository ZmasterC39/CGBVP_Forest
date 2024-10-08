import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'indentifical_personal.dart'; // Asegúrate de que el nombre del archivo es correcto

class EstrategiasPage extends StatefulWidget {
  final String incidentId;

  EstrategiasPage({required this.incidentId});

  @override
  _EstrategiasPageState createState() => _EstrategiasPageState();
}

class _EstrategiasPageState extends State<EstrategiasPage> {
  // Campos para Identificar peligros y riesgos
  List<String> _selectedPeligros = [];
  String _otherPeligro = '';

  // Campo para Establecer periodo operacional
  String _selectedPeriodoOperacional = 'Hasta 4 horas';

  // Campos para Asignación Estrategias
  List<String> _selectedEstrategias = [];
  String _otherEstrategia = '';

  // Campo para fecha preestablecida (actual o personalizada)
  DateTime _fecha = DateTime.now(); // Puedes modificar esta fecha si lo necesitas

  // Otros campos existentes
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
          'horaInicio': _startTime,
          'fecha': Timestamp.fromDate(_fecha), // Usando la fecha preestablecida
          'peligrosRiesgos': _selectedPeligros,
          'otroPeligro': _otherPeligro,
          'periodoOperacional': _selectedPeriodoOperacional,
          'asignacionEstrategias': _selectedEstrategias,
          'otraEstrategia': _otherEstrategia,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estrategias guardadas correctamente')),
      );

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
                      IdentificarPersonalPage(incidentId: widget.incidentId),
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
    // Listas de opciones
    final List<String> peligrosOptions = [
      'Tocones quemados',
      'Material peligroso',
      'Problemas de evacuación',
      'Interfaz',
      'Caída de árboles',
      'Otros',
    ];

    final List<String> periodoOperacionalOptions = [
      'Hasta 4 horas',
      'Hasta 12 horas',
      'Hasta 24 horas',
    ];

    final List<String> asignacionEstrategiasOptions = [
      'Ataque directo con herramientas manuales',
      'Ataque directo con líneas de agua y/o medios aéreos',
      'Ataque indirecto',
      'Ataque indirecto paralelo',
      'Liquidación',
      'Esperar ventanas, zonas de oportunidad',
      'Otros',
    ];

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
              // Fecha preestablecida (solo visual)
              ListTile(
                title: Text('Fecha: ${_fecha.toLocal()}'.split(' ')[0]), // Muestra la fecha preestablecida
              ),
              SizedBox(height: 20),

              // Identificar peligros y riesgos
              Text(
                'Identificar peligros y riesgos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...peligrosOptions.map((peligro) {
                if (peligro != 'Otros') {
                  return CheckboxListTile(
                    title: Text(peligro),
                    value: _selectedPeligros.contains(peligro),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedPeligros.add(peligro);
                        } else {
                          _selectedPeligros.remove(peligro);
                        }
                      });
                    },
                  );
                } else {
                  return CheckboxListTile(
                    title: Text('Otros'),
                    value: _selectedPeligros.contains('Otros'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedPeligros.add('Otros');
                        } else {
                          _selectedPeligros.remove('Otros');
                          _otherPeligro = '';
                        }
                      });
                    },
                  );
                }
              }).toList(),
              // Campo de texto para 'Otros' en peligros
              if (_selectedPeligros.contains('Otros'))
                TextFormField(
                  decoration: InputDecoration(labelText: 'Especificar otros peligros'),
                  onChanged: (value) {
                    _otherPeligro = value;
                  },
                ),
              SizedBox(height: 20),

              // Establecer periodo operacional
              DropdownButtonFormField<String>(
                value: _selectedPeriodoOperacional,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPeriodoOperacional = newValue!;
                  });
                },
                items: periodoOperacionalOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration:
                    InputDecoration(labelText: 'Establecer periodo operacional'),
              ),
              SizedBox(height: 20),

              // Asignación Estrategias
              Text(
                'Asignación Estrategias',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...asignacionEstrategiasOptions.map((estrategia) {
                if (estrategia != 'Otros') {
                  return CheckboxListTile(
                    title: Text(estrategia),
                    value: _selectedEstrategias.contains(estrategia),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedEstrategias.add(estrategia);
                        } else {
                          _selectedEstrategias.remove(estrategia);
                        }
                      });
                    },
                  );
                } else {
                  return CheckboxListTile(
                    title: Text('Otros'),
                    value: _selectedEstrategias.contains('Otros'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedEstrategias.add('Otros');
                        } else {
                          _selectedEstrategias.remove('Otros');
                          _otherEstrategia = '';
                        }
                      });
                    },
                  );
                }
              }).toList(),
              // Campo de texto para 'Otros' en estrategias
              if (_selectedEstrategias.contains('Otros'))
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Especificar otras estrategias'),
                  onChanged: (value) {
                    _otherEstrategia = value;
                  },
                ),
              SizedBox(height: 20),

              // Botón para guardar
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
