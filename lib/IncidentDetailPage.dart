import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentDetailPage extends StatelessWidget {
  final String incidentId;

  IncidentDetailPage({required this.incidentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Incidente'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('incidentes').doc(incidentId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var incident = snapshot.data!;
          var data = incident.data() as Map<String, dynamic>;

          // Mostrar detalles del incidente
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text('Código de Bomberos: ${data['evaluacionInicial']['codigoBomberos'] ?? ''}'),
              Text('Ubicación: ${data['evaluacionInicial']['ubicacionGeografica'] ?? ''}'),
              
            ],
          );
        },
      ),
    );
  }
}
