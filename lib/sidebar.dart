import 'package:flutter/material.dart';
import 'package:wereads/dashboards.dart';
import 'package:wereads/login_page.dart';
import 'enquiry.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header with Gradient Background and Profile Picture
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.book, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Advocate Diary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Run office from your pocket...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Enquiry'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const enquiryScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Client'),
            onTap: () {
              Navigator.pushNamed(context, '/client');
            },
          ),
          ListTile(
            leading: const Icon(Icons.details),
            title: const Text('Detail'),
            onTap: () {
              Navigator.pushNamed(context, '/detail');
            },
          ),
          ListTile(
            leading: const Icon(Icons.meeting_room),
            title: const Text('Meeting'),
            onTap: () {
              Navigator.pushNamed(context, '/meeting');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Advocate'),
            onTap: () {
              Navigator.pushNamed(context, '/advocate');
            },
          ),
          const Divider(), // Adds a divider between sections
          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
