import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluacionesDesempenoListPage extends StatelessWidget {
  final String incidentId;

  EvaluacionesDesempenoListPage({required this.incidentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluaciones de Desempeño'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Evaluación de desempeño')
            .where('incidentId', isEqualTo: incidentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> evaluaciones = snapshot.data!.docs;

          if (evaluaciones.isEmpty) {
            return Center(child: Text('No hay evaluaciones registradas'));
          }

          return ListView.builder(
            itemCount: evaluaciones.length,
            itemBuilder: (context, index) {
              var evaluacion = evaluaciones[index];
              var data = evaluacion.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['nombre'] ?? ''),
                subtitle: Text('Evaluación: ${data['evaluacion'] ?? ''}'),
                onTap: () {
                  // Opcional: Navegar a una página de detalles de la evaluación
                },
              );
            },
          );
        },
      ),
    );
  }
}
