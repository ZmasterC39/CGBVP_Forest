import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _prifIdController = TextEditingController();
  
  String _selectedTaskForce = 'FT 1 Cusco';
  final _formKey = GlobalKey<FormState>();

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;
      String name = _nameController.text;
      String surname = _surnameController.text;
      String prifId = _prifIdController.text;
      String taskForce = _selectedTaskForce;

      try {
        // Crear el usuario con Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        // Validar si existe la colección de 'users', si no, crearla
        DocumentSnapshot doc = await _firestore.collection('users').doc(user!.uid).get();
        if (!doc.exists) {
          // Guardar la información del usuario en Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'username': username,
            'name': name,
            'surname': surname,
            'email': email,
            'prifId': prifId,
            'taskForce': taskForce,
            'createdAt': Timestamp.now(),
          });
        }

        // Actualizar el nombre de usuario en Firebase Authentication
        await user.updateDisplayName(username);

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario $username creado exitosamente')),
        );

        Navigator.pushReplacementNamed(context, '/public_user');
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prifIdController,
                decoration: InputDecoration(labelText: 'Identificación PRIF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu identificación PRIF';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  } else if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Repite la contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirma la contraseña';
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createUser,
                child: Text('Crear Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
