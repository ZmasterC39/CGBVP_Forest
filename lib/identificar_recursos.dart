import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IdentificarRecursosPage extends StatefulWidget {
  @override
  _IdentificarRecursosPageState createState() => _IdentificarRecursosPageState();
}

class _IdentificarRecursosPageState extends State<IdentificarRecursosPage> {
  final _bomberosController = TextEditingController();
  final _uboController = TextEditingController();
  String _selectedGrade = 'Seccionario';
  String _selectedPosition = 'Comandante de Incidente (CI)';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveRecursos() async {
    try {
      User? user = _auth.currentUser;
      await _firestore.collection('recursos').add({
        'usuarioId': user?.uid ?? '',
        'bomberos': _bomberosController.text,
        'grado': _selectedGrade,
        'ubo': _uboController.text,
        'posicion': _selectedPosition,
        'fechaHora': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recursos identificados correctamente')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al identificar los recursos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Seccionario', 'Sub Teniente', 'Teniente', 'Capitán', 
                'Tnte. Brigadier', 'Brigadier', 'Brigadier Mayor', 'Brigadier General',
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
