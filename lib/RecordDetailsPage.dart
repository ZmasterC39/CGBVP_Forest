
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class RecordDetailsPage extends StatelessWidget {
  final String recordId;

  const RecordDetailsPage({required this.recordId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Incidente Crítico"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('ubo_incidents')
            .doc(recordId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final record = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre de la UBO: ${record['uboName']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Estado de los recursos: ${record['resourceStatus']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Estado del personal: ${record['personnelStatus']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Ubicación: ${record['location']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Observaciones: ${record['observations']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await actualizarEstadoRegistro(recordId, 'aceptado');
                        Navigator.pop(context);
                      },
                      child: const Text("Aceptar"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await actualizarEstadoRegistro(recordId, 'rechazado');
                        Navigator.pop(context);
                      },
                      child: const Text("Rechazar"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> actualizarEstadoRegistro(String recordId, String status) async {
    await FirebaseFirestore.instance
        .collection('ubo_incidents')
        .doc(recordId)
        .update({'status': status});
  }

  Future<void> eliminarRegistro(String recordId) async {
    await FirebaseFirestore.instance
        .collection('ubo_incidents')
        .doc(recordId)
        .delete();
  }
}
