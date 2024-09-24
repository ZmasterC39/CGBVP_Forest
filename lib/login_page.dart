import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/public_user');
    } catch (e) {
      print(e);
    }
  }

  // Función para detectar si es email o usuario
  bool _isEmail(String input) {
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(input);
  }

  Future<void> _signInWithEmailOrUsername() async {
    if (_formKey.currentState!.validate()) {
      String login = _loginController.text;
      String password = _passwordController.text;

      try {
        if (_isEmail(login)) {
          // Iniciar sesión con correo electrónico
          await _auth.signInWithEmailAndPassword(
            email: login,
            password: password,
          );
        } else {
          // Buscar el usuario por nombre de usuario
          // Aquí debes implementar una función para mapear el nombre de usuario al email
          String email = await _getEmailFromUsername(login);
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        }
        // Redirigir a la página pública
        Navigator.pushReplacementNamed(context, '/public_user');
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión')),
        );
      }
    }
  }

  // Función simulada para obtener el email a partir del nombre de usuario
  Future<String> _getEmailFromUsername(String username) async {
    // Aquí puedes implementar una búsqueda real en una base de datos
    return "email@example.com";  // Simulación: retorna un email válido
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CGBVP Emergencias Forestales'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Correo o Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo o nombre de usuario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithEmailOrUsername,
                child: Text('Iniciar Sesión'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create_user');
                },
                child: Text('¿No tienes cuenta? Regístrate aquí'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: Image.asset('assets/google_icon.png', height: 20),
                label: Text('Iniciar Sesión con Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
