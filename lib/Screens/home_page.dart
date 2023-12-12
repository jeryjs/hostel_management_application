import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_management_application/database.dart';

import '../Models/hostel_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator.adaptive(
        onRefresh: () async => setState(() { }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/HotelManagementSystem.webp', height: 200),
            const SizedBox(height: 64),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot<Object?>>>(
                future: dbService.getHostels(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final hostels = snapshot.data!.map((e) => Hostel.fromJson(e.data())).toList();
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
    );
  }

  Widget hostelCard(Hostel h) {
    final clr = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => debugPrint(h.name),
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
                onPressed: () {},
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
