import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class AdminCreateRecordPage extends StatefulWidget {
  const AdminCreateRecordPage({super.key});

  @override
  _AdminCreateRecordPageState createState() => _AdminCreateRecordPageState();
}

class _AdminCreateRecordPageState extends State<AdminCreateRecordPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos relevantes para la encuesta UBO
  String uboName = '', resourceStatus = '', personnelStatus = '', location = '', observations = '';
  String feedbackMessage = '';
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Encuesta UBO"),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Registrar Nueva Encuesta UBO",
                style: TextStyle(fontSize: 24),
              ),
            ),
            if (feedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  feedbackMessage,
                  style: TextStyle(color: feedbackMessage.startsWith('Error') ? Colors.red : Colors.green, fontSize: 16),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildUboNameField(),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    buildResourceStatusField(),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    buildPersonnelStatusField(),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    buildLocationField(),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    buildObservationsField(),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Campo para el nombre de la UBO
  Widget buildUboNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nombre de la UBO",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSaved: (String? value) {
        uboName = value ?? '';
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  // Campo para el estado de los recursos
  Widget buildResourceStatusField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Estado de los recursos",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSaved: (String? value) {
        resourceStatus = value ?? '';
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  // Campo para el estado del personal
  Widget buildPersonnelStatusField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Estado del personal",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSaved: (String? value) {
        personnelStatus = value ?? '';
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  // Campo para la ubicación (coordenadas)
  Widget buildLocationField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Ubicación (Coordenadas)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSaved: (String? value) {
        location = value ?? '';
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  // Campo para observaciones adicionales
  Widget buildObservationsField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Observaciones",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSaved: (String? value) {
        observations = value ?? '';
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  // Botón de enviar
  Widget buildSubmitButton() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await crearEncuestaUbo();
          }
        },
        child: const Text("Enviar Encuesta"),
      ),
    );
  }

  // Método para guardar la encuesta UBO en Firestore
  Future<void> crearEncuestaUbo() async {
    try {
      await FirebaseFirestore.instance.collection('ubo_records').add({
        'uboName': uboName,
        'resourceStatus': resourceStatus,
        'personnelStatus': personnelStatus,
        'location': location,
        'observations': observations,
        'status': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
        'userEmail': FirebaseAuth.instance.currentUser?.email,
      });
      setState(() {
        feedbackMessage = "Encuesta creada correctamente.";
      });
    } catch (e) {
      setState(() {
        feedbackMessage = "Error al crear la encuesta: $e";
      });
    }
  }
}
