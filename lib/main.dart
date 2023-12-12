import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostels Manager',
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.location_on,
              color: Theme.of(context).colorScheme.primary, size: 28),
          title: const Text('Some University',
              style: TextStyle(fontFamily: 'inkfree')),
        ),
        body: const HomePage(),
      ),
    );
  }
}
