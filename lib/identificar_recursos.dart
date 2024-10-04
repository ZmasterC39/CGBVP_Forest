import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IdentificarRecursosPage extends StatefulWidget {
  final String incidentId;

  IdentificarRecursosPage({required this.incidentId});

  @override
  _IdentificarRecursosPageState createState() => _IdentificarRecursosPageState();
}

class _IdentificarRecursosPageState extends State<IdentificarRecursosPage> {
  final _bomberosController = TextEditingController();
  final _uboController = TextEditingController();
  String _selectedGrade = 'Seccionario';
  String _selectedPosition = 'Comandante de Incidente (CI)';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    try {
      DocumentSnapshot incidentSnapshot =
          await _firestore.collection('incidentes').doc(widget.incidentId).get();

      if (incidentSnapshot.exists) {
        var data = incidentSnapshot.data() as Map<String, dynamic>;
        var recursos = data['recursos'] as Map<String, dynamic>?;

        if (recursos != null) {
          _bomberosController.text = recursos['bomberos'] ?? '';
          _uboController.text = recursos['ubo'] ?? '';
          _selectedGrade = recursos['grado'] ?? 'Seccionario';
          _selectedPosition = recursos['posicion'] ?? 'Comandante de Incidente (CI)';
        }
      }
    } catch (e) {
      print('Error al cargar datos existentes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos existentes')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecursos() async {
    try {
      DocumentReference incidentRef =
          _firestore.collection('incidentes').doc(widget.incidentId);

      await incidentRef.update({
        'recursos': {
          'bomberos': _bomberosController.text,
          'grado': _selectedGrade,
          'ubo': _uboController.text,
          'posicion': _selectedPosition,
          'fechaHora': Timestamp.now(),
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recursos guardados correctamente')),
      );

      Navigator.pop(context); // Regresar a la página anterior
    } catch (e) {
      print('Error al guardar recursos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los recursos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostrar un indicador de carga mientras se obtienen los datos
      return Scaffold(
        appBar: AppBar(
          title: Text('Identificar Recursos'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Identificar Recursos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _bomberosController,
              decoration: InputDecoration(labelText: 'Bomberos que arribaron a la escena'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedGrade,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGrade = newValue!;
                });
              },
              items: <String>[
                'Seccionario',
                'Sub Teniente',
                'Teniente',
                'Capitán',
                'Tnte. Brigadier',
                'Brigadier',
                'Brigadier Mayor',
                'Brigadier General',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Grado del personal'),
            ),
            TextFormField(
              controller: _uboController,
              decoration: InputDecoration(labelText: 'UBO'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedPosition,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                });
              },
              items: <String>[
                'Comandante de Incidente (CI)',
                'Combatiente de Incendios Forestal (COIF)',
                'Jefe de Cuadrilla (JECU)',
                'Jefe Brigada (JEFB)',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Posición'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecursos,
              child: Text('Guardar Recursos'),
            ),
          ],
        ),
      ),
    );
  }
}
