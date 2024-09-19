import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class PublicUserPage extends StatefulWidget {
  const PublicUserPage({super.key});

  @override
  _PublicUserPageState createState() => _PublicUserPageState();
}

class _PublicUserPageState extends State<PublicUserPage> {
  final _formKey = GlobalKey<FormState>();
  String uboName = '', resourceStatus = '', personnelStatus = '', location = '';
  String feedbackMessage = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Encuesta UBO"),
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
                  style: TextStyle(
                      color: feedbackMessage.startsWith('Error')
                          ? Colors.red
                          : Colors.green,
                      fontSize: 16),
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
                    buildSubmitButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Mis Registros"),
            buildUserRecordsList(),
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
        labelText: "Estado de los Recursos",
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
        labelText: "Estado del Personal",
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

  // Campo para la ubicación de la UBO
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

  // Botón de enviar
  Widget buildSubmitButton() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await crearRegistroUbo();
          }
        },
        child: const Text("Enviar Encuesta"),
      ),
    );
  }

  // Crear el registro de la encuesta UBO en Firestore
  Future<void> crearRegistroUbo() async {
    try {
      await FirebaseFirestore.instance.collection('ubo_records').add({
        'uboName': uboName,
        'resourceStatus': resourceStatus,
        'personnelStatus': personnelStatus,
        'location': location,
        'status': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
        'userEmail': FirebaseAuth.instance.currentUser?.email,
      });
      setState(() {
        feedbackMessage = "Registro creado correctamente.";
      });
    } catch (e) {
      setState(() {
        feedbackMessage = "Error al crear el registro: $e";
      });
    }
  }

  // Lista de registros del usuario
  Widget buildUserRecordsList() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Text("Error: Usuario no autenticado.");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('ubo_records')
          .where('userEmail', isEqualTo: user.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error al cargar los registros.");
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final records = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            final data = record.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['uboName']),
              subtitle: Text('Recursos: ${data['resourceStatus']}'),
            );
          },
        );
      },
    );
  }
}
