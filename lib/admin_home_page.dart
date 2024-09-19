import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'admin_create_record_page.dart';
import 'notificaciones_page.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Página Principal Administrativa"),
        actions: [
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminCreateRecordPage()));
            },
            child: const Text("Crear Encuesta UBO"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificacionesPage()));
            },
            child: const Text("Notificaciones"),
          ),
          const SizedBox(height: 20),
          const Text("Encuestas Aceptadas"),
          Expanded(child: buildAcceptedRecordsList()),
        ],
      ),
    );
  }

  // Construir la lista de encuestas aceptadas
  Widget buildAcceptedRecordsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ubo_records')
          .where('status', isEqualTo: 'aceptado')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error al cargar las encuestas.");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final records = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            var record = records[index];
            var sentAt = (record['sentAt'] as Timestamp).toDate();
            var date = DateFormat.yMMMd().format(sentAt);
            var time = DateFormat.jm().format(sentAt);
            return ListTile(
              title: Text('${record['uboName']} - ${record['userEmail']}'),
              subtitle: Text('Recursos: ${record['resourceStatus']} - Enviado el $date a las $time'),
              trailing: Text(record['personnelStatus']),
            );
          },
        );
      },
    );
  }
}
