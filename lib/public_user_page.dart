import 'package:flutter/material.dart';
import 'evaluacion.dart';
import 'estrategias.dart';
import 'identificar_recursos.dart';
import 'desmovilizacion.dart';  // Importamos desmovilizacion.dart
import 'profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PublicUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public User Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EvaluacionPage()),
                );
              },
              child: Text('Evaluación Inicial'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstrategiasPage()),
                );
              },
              child: Text('Determinar Estrategias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IdentificarRecursosPage()),
                );
              },
              child: Text('Identificar recursos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DesmovilizacionPage()),
                );
              },
              child: Text('Desmovilización'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Text('Perfil'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
