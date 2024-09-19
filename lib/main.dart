import 'package:flutter/material.dart';
import 'count.dart';  // Archivo del contador
import 'home.dart';  // Archivo donde tienes tu HomePage con las rutas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),  // Página inicial
        '/counter': (context) => const MyHomePage(title: 'Contador'),  // Ruta del contador
        '/notifications': (context) => const NotificacionesPage(),  // Ruta de notificaciones
      },
    );
  }
}
