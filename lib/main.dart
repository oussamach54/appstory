import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/home.page.dart';
import 'Screens/login.page.dart';
import 'Screens/register.page.dart';
import 'Screens/camera_page.dart';
import 'Screens/dashboard_page.dart'; 
import 'Screens/historique_page.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDQUy5tDNcAip1XYAdGQyFRjT3ZYitiNlg",
        authDomain: "myapp1-74cdc.firebaseapp.com",
        projectId: "myapp1-74cdc",
        storageBucket: "myapp1-74cdc.appspot.com",
        messagingSenderId: "504962420374",
        appId: "1:504962420374:web:39ab160d47b6586ee9bcb7",
        measurementId: "G-H56YN9P7DS",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Default route
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/camera': (context) => const CameraPage(),
        '/dashboard': (context) => const DashboardPage(), 
        '/historique': (context) => const HistoriquePage(), 

      },
    );
  }
}
