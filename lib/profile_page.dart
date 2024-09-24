import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _prifIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedTaskForce = 'FT 1 Cusco';

  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _emailController.text = user?.email ?? '';
    _nameController.text = user?.displayName ?? '';
    _loadUserData(); // Cargar datos adicionales desde Firestore
  }

  // Cargar los datos adicionales desde Firestore
  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        _surnameController.text = data?['surname'] ?? '';
        _usernameController.text = data?['username'] ?? '';
        _prifIdController.text = data?['prifId'] ?? '';
        _selectedTaskForce = data?['taskForce'] ?? 'FT 1 Cusco';
        setState(() {});
      }
    }
  }

  // Actualizar el perfil del usuario en FirebaseAuth y Firestore
  Future<void> _updateProfile() async {
    try {
      // Actualizar los datos en Firebase Authentication
      if (_nameController.text.isNotEmpty) {
        await user?.updateDisplayName(_nameController.text);
      }
      if (_emailController.text.isNotEmpty) {
        await user?.updateEmail(_emailController.text);
      }
      if (_passwordController.text.isNotEmpty && _passwordController.text.length >= 6) {
        await user?.updatePassword(_passwordController.text);
      }

      // Validar si la colección existe, si no, crearla
      DocumentSnapshot doc = await _firestore.collection('users').doc(user!.uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(user!.uid).set({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'username': _usernameController.text,
          'prifId': _prifIdController.text,
          'taskForce': _selectedTaskForce,
          'email': _emailController.text,
        });
      } else {
        // Actualizar los datos adicionales en Firestore
        await _firestore.collection('users').doc(user!.uid).update({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'username': _usernameController.text,
          'prifId': _prifIdController.text,
          'taskForce': _selectedTaskForce,
          'email': _emailController.text,
        });
      }

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _prifIdController,
              decoration: InputDecoration(labelText: 'Identificador PRIF'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedTaskForce,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTaskForce = newValue!;
                });
              },
              items: <String>[
                'FT 1 Cusco', 'FT 2 Lima', 'FT 3 Cajamarca', 'FT 4 Ancash', 'FT 5 Junin Centro',
                'FT 6 Piura', 'FT 7 Yurimaguas-San Martín', 'FT 8 Apurimac', 'FT 9 Amazonas', 
                'FT 10 Ayacucho-VRAEM', 'FT 11 Huánuco', 'FT 12 Puno', 'FT 13 Arequipa', 'FT 14 Tacna',
                'FT 15 Ucayali', 'FT 16 Junin Oriente', 'FT 17 Huancavelica', 'FT 18 Ica', 'FT 19 Moquegua',
                'FT 20 Loreto', 'FT 21 Tumbes', 'FT 22 Madre de Dios', 'FT 23 Lambayeque', 'FT 24 La Libertad',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Fuerza de Tarea PRIF'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Cambiar Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Actualizar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
