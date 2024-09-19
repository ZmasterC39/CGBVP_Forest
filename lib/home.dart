import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Página Principal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/counter');
              },
              child: const Text("Ir al Contador"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              child: const Text("Notificacionesaaa"),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
      ),
      body: const Center(
        child: Text("Página de Notificaciones"),
      ),
    );
  }
}
