import 'package:flutter/material.dart';

import '../Components/circle_reveal_clipper.dart';
import '../database.dart';
import '../Models/hostel_model.dart';
import '../Screens/students_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService dbService = DatabaseService();
  late var hostels = dbService.getHostels();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator.adaptive(
          onRefresh: () async => setState(() {
            hostels = dbService.getHostels();
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/HostelManagementSystem.webp',
                  height: 200),
              const SizedBox(height: 64),
              Expanded(
                child: FutureBuilder<List<Hostel>>(
                  future: hostels,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final hostels = snapshot.data!;
                      return ListView.builder(
                        itemCount: hostels.length,
                        itemBuilder: (context, index) {
                          return hostelCard(hostels[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget hostelCard(Hostel h) {
    final clr = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const StudentsPage(),
            transitionDuration: const Duration (milliseconds: 500),
            // reverseTransitionDuration: const Duration(milliseconds: 2000) ,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var screenSize = MediaQuery.of(context).size;
              return ClipPath(
                clipper: CircleRevealClipper(
                  radius: animation
                      .drive(Tween(begin: 0.0, end: screenSize.height * 1.5))
                      .value,
                  center: Offset(screenSize.width, screenSize.height/2),
                ),
                child: child,
              );
            },
          ),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(h.imageUrl),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Warden: ',
                        children: [
                          TextSpan(
                              text: h.warden,
                              style: const TextStyle(fontSize: 16))
                        ],
                      ),
                      style: TextStyle(fontSize: 14, color: clr.primary),
                    ),
                    Text(h.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('${h.studentCount} Students',
                        style: TextStyle(fontSize: 14, color: clr.secondary)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const StudentsPage())),
                icon: const Icon(Icons.arrow_forward_ios, size: 36),
                tooltip: 'Manage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
