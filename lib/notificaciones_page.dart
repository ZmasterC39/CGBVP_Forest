import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'RecordDetailsPage.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones de Incidentes Críticos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ubo_incidents')
            .where('status', isEqualTo: 'pendiente')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data!.docs;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                title: Text(record['uboName']),
                subtitle:
                    Text('Recursos críticos: ${record['resourceStatus']}'),
                trailing: Text('Estado: ${record['status']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecordDetailsPage(recordId: record.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
