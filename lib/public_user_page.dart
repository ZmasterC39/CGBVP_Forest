import 'package:flutter/material.dart';
import 'evaluacion.dart';
import 'profile_page.dart';
import 'IncidentListPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PublicUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con título y acciones
      appBar: AppBar(
        title: Text('Emergencias Forestales'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navegar al perfil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      // Menú lateral (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Menú Principal',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: Colors.green[700],
              ),
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('Evaluación Inicial'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EvaluacionPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Mis Incidentes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IncidentListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      // Cuerpo principal con tarjetas
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen o banner principal
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/forest_fire.jpg'), // Asegúrate de tener esta imagen en assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Opciones principales
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Tarjeta de Evaluación Inicial
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.assessment, color: Colors.blue),
                      title: Text('Evaluación Inicial'),
                      subtitle: Text('Inicia una nueva evaluación'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EvaluacionPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // Tarjeta de Mis Incidentes
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.list, color: Colors.orange),
                      title: Text('Mis Incidentes'),
                      subtitle: Text('Consulta tus incidentes registrados'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IncidentListPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // Tarjeta de Perfil
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.green),
                      title: Text('Perfil'),
                      subtitle: Text('Edita tu información personal'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
