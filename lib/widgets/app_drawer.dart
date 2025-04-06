import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'User'),
            accountEmail: Text(user?.email ?? 'No email'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user != null && user.displayName != null && user.displayName!.isNotEmpty
                    ? user.displayName![0].toUpperCase()
                    : (user != null && user.email != null && user.email!.isNotEmpty
                        ? user.email![0].toUpperCase()
                        : 'U'),
                style: const TextStyle(fontSize: 24.0, color: Colors.blue),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Spinalergalant Trainer'),
            onTap: () {
              Navigator.pushNamed(context, '/spinalergalant');
            },
          ),
          ListTile(
            leading: const Icon(Icons.accessibility_new),
            title: const Text('Moro Trainer'),
            onTap: () {
              Navigator.pushNamed(context, '/moro');
            },
          ),
          // Additional navigation items can be added here.
        ],
      ),
    );
  }
}
