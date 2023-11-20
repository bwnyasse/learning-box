import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../auth/auth_service.dart';

AuthService get authService => Modular.get<AuthService>();

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text('Invoices'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   CircleAvatar(
                    backgroundImage: NetworkImage(authService.getUser().photoURL),
                    radius: 40,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Welcome, ${authService.getUser().displayName.split(' ')[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                authService.signOut();
              },
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: 100, // Replace with the actual number of invoices
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading:
                const Icon(Icons.description), // Replace with a relevant icon
            title: Text('Invoice #$index'), // Replace with actual invoice name
            onTap: () {
              // Navigate to the invoice details page
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Charts',
          ),
        ],
        currentIndex: 0,
      ),
    );
  }
}
