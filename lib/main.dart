import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'create_user_page.dart';
import 'public_user_page.dart';
import 'profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGBVP Emergencias Forestales',
      theme: ThemeData(
        
        primarySwatch: Colors.green,
        hintColor: Colors.orangeAccent,
        fontFamily: 'Roboto',
      ),
      home: AuthenticationWrapper(),
      routes: {
        '/login': (context) => LoginPage(),
        '/create_user': (context) => CreateUserPage(),
        '/public_user': (context) => PublicUserPage(), // Elimina incidentId
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); 
        } else if (snapshot.hasData) {
          // Usuario autenticado, redirige a PublicUserPage
          return PublicUserPage();
        } else {
          // Usuario no autenticado
          return LoginPage();
        }
      },
    );
  }
}
