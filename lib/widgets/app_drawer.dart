import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<void> _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // After signing out, navigate to the login screen.
    Navigator.pushReplacementNamed(context, '/login');
  }

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
          // Neuer Eintrag für Sound-Pakete
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('Sound-Pakete'),
            onTap: () {
              Navigator.pushNamed(context, '/sound-settings');
            },
          ),
          // Logoff button
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () async {
              await _logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
