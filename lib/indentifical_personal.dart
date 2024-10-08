import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'desmovilizacion.dart';

class IdentificarPersonalPage extends StatefulWidget {
  final String incidentId;

  IdentificarPersonalPage({required this.incidentId});

  @override
  _IdentificarPersonalPageState createState() => _IdentificarPersonalPageState();
}

class _IdentificarPersonalPageState extends State<IdentificarPersonalPage> {
  final _bomberosController = TextEditingController();
  final _unidadesController = TextEditingController();

  // Recursos adicionales seleccionados
  List<String> _selectedRecursosAdicionales = [];

  // Opciones de recursos adicionales
  final List<String> _recursosAdicionalesOptions = [
    'Personal',
    'Provisión de herramientas',
    'Maquinaria pesada',
    'Cisternas',
    'Medios aéreos',
    'Otros',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveIdentificacionPersonal() async {
    try {
      DocumentReference incidentRef =
          _firestore.collection('incidentes').doc(widget.incidentId);

      await incidentRef.update({
        'identificacionPersonal': {
          'totalBomberos': int.tryParse(_bomberosController.text) ?? 0,
          'totalUnidades': int.tryParse(_unidadesController.text) ?? 0,
          'recursosAdicionales': _selectedRecursosAdicionales,
          'fechaHora': Timestamp.now(),
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Identificación de personal guardada correctamente')),
      );

      // Navegar a la siguiente página: DesmovilizacionPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DesmovilizacionPage(incidentId: widget.incidentId),
        ),
      );
    } catch (e) {
      print('Error al guardar identificación de personal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la identificación de personal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identificar Personal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campo: Total de bomberos que arribaron a la escena
            TextFormField(
              controller: _bomberosController,
              decoration: InputDecoration(
                labelText: 'Total de bomberos que arribaron a la escena',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Campo: Total de unidades del CGBVP movilizadas a la escena
            TextFormField(
              controller: _unidadesController,
              decoration: InputDecoration(
                labelText: 'Total de unidades del CGBVP movilizadas a la escena',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Campo: Recursos adicionales
            Text(
              'Recursos adicionales:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ..._recursosAdicionalesOptions.map((recurso) {
              return CheckboxListTile(
                title: Text(recurso),
                value: _selectedRecursosAdicionales.contains(recurso),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedRecursosAdicionales.add(recurso);
                    } else {
                      _selectedRecursosAdicionales.remove(recurso);
                    }
                  });
                },
              );
            }).toList(),
            SizedBox(height: 20),
            // Botón para guardar
            ElevatedButton(
              onPressed: _saveIdentificacionPersonal,
              child: Text('Guardar y Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
