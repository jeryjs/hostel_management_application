import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hostel_management_application/Screens/chat_page.dart';
import 'package:hostel_management_application/Screens/students_page.dart';

import 'Screens/home_page.dart';
import 'firebase_options.dart';

/// The main entry point of the application.
/// Initializes Firebase and runs the [MainApp] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

/// The root widget of the application.
/// Manages the state of the bottom navigation bar and the page view.
class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

/// The state of the [MainApp] widget.
/// Manages the current index of the bottom navigation bar and the page controller.
class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

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
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(content: Text('Press back again to close')),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              HomePage(),
              StudentsPage(),
              ChatPage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Hostels',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Students',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
          ],
        ),
      ),
    );
  }
}
