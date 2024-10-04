import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'IncidentDetailPage.dart';
import 'evaluacion.dart';
import 'estrategias.dart';
import 'desmovilizacion.dart';
import 'identificar_recursos.dart';

class IncidentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Incidentes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('incidentes')
            .where('usuarioId', isEqualTo: user?.uid)
            .orderBy('fechaInicio', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> incidents = snapshot.data!.docs;

          if (incidents.isEmpty) {
            return Center(child: Text('No tienes incidentes registrados'));
          }

          return ListView.builder(
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              var incident = incidents[index];
              var data = incident.data() as Map<String, dynamic>;

              String estado = data['estado'] ?? 'incompleto';
              String incidenteId = incident.id;

              // Verificar el progreso del incidente
              bool evaluacionInicialCompletada =
                  data.containsKey('evaluacionInicial');
              bool estrategiasCompletadas = data.containsKey('estrategias');
              bool desmovilizacionCompletada =
                  data.containsKey('desmovilizacion');
              bool recursosIdentificados = data.containsKey('recursos');

              return ListTile(
                title: Text('Incidente $incidenteId'),
                subtitle: Text('Fecha: ${data['fechaInicio'].toDate()}'),
                trailing: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (String value) {
                    if (value == 'Continuar') {
                      _continueIncident(context, incidenteId, data);
                    } else if (value == 'EvaluacionRecursos') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IdentificarRecursosPage(incidentId: incidenteId),
                        ),
                      );
                    } else if (value == 'Detalles') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IncidentDetailPage(incidentId: incidenteId),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> options = [];

                    // Mostrar 'Continuar' si el incidente está incompleto
                    if (estado == 'incompleto') {
                      options.add(
                        PopupMenuItem<String>(
                          value: 'Continuar',
                          child: Text('Continuar'),
                        ),
                      );
                    }

                    // Mostrar 'Evaluación de Recursos' si aún no se ha hecho
                    if (!recursosIdentificados) {
                      options.add(
                        PopupMenuItem<String>(
                          value: 'EvaluacionRecursos',
                          child: Text('Evaluación de Recursos'),
                        ),
                      );
                    }

                    // Opción para 'Detalles'
                    options.add(
                      PopupMenuItem<String>(
                        value: 'Detalles',
                        child: Text('Detalles'),
                      ),
                    );

                    return options;
                  },
                ),
                onTap: () {
                  // También puedes navegar a los detalles al tocar el ListTile
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IncidentDetailPage(incidentId: incidenteId),
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

  void _continueIncident(
      BuildContext context, String incidentId, Map<String, dynamic> data) {
    if (!data.containsKey('estrategias')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EstrategiasPage(incidentId: incidentId),
        ),
      );
    } else if (!data.containsKey('desmovilizacion')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DesmovilizacionPage(incidentId: incidentId),
        ),
      );
    } else {
      // Este caso no debería ocurrir si el estado se actualiza correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El incidente ya está completo')),
      );
    }
  }
}
