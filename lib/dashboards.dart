import 'package:flutter/material.dart';
import 'package:wereads/cases/advocate.dart';
import 'package:wereads/cases/matters.dart';
import 'package:wereads/client/clientlist.dart';
import 'package:wereads/client/daily_activity_list.dart';
import 'package:wereads/login_page.dart';
import 'package:wereads/sidebar.dart';
import 'package:wereads/todo_add.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/sam.webp', height: 70),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: const SideBar(),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWelcomeSection(context),
              _buildContentSection(context),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Mon, December 9, 2024',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final List<String> serviceLabels = [
      'Matters',
      'Client',
      'Advocate',
      'Activity',
      'Certified',
      'eSCR',
      'Office',
      'Display',
    ];

    final List<IconData> serviceIcons = [
      Icons.list,
      Icons.search,
      Icons.today,
      Icons.book,
      Icons.copy,
      Icons.description,
      Icons.report,
      Icons.dashboard,
    ];

    final List<Widget> servicePages = List.generate(
      serviceLabels.length,
      (index) {
        if (index == 1) {
          return const CustomerListScreen(); // Open CustomerListScreen for the second button
        }
        if (index == 2) {
          return const AdvocateListScreen();
        }
        if (index == 3) {
          return const DailyActivityList();
        }
        if (index == 4) {
          return const todolist();
        }
        return TodayCasesPage(); // Default placeholder page
      },
    );
    final List<String> featureLabels = [
      'Act',
      'Rules',
      'Circulars',
      'Practice',
      'Disclaimer',
      'Feedback',
      'SCR',
      'Contact Us',
    ];

    final List<IconData> featureIcons = [
      Icons.gavel,
      Icons.rule,
      Icons.notifications,
      Icons.bookmark,
      Icons.info,
      Icons.feedback,
      Icons.book_online,
      Icons.contact_mail,
    ];

    final List<Widget> featurePages = List.generate(
        featureLabels.length, (index) => TodayCasesPage()); // Placeholder pages

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGridSection(
              context, 'eServices', serviceIcons, serviceLabels, servicePages),
          const SizedBox(height: 24.0),
          _buildGridSection(context, 'Key Features', featureIcons,
              featureLabels, featurePages),
        ],
      ),
    );
  }

  Widget _buildGridSection(BuildContext context, String title,
      List<IconData> icons, List<String> labels, List<Widget> pages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pages[index]),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icons[index],
                      size: 40, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8.0),
                  Text(
                    labels[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/images.png',
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.withOpacity(0.7),
          alignment: Alignment.center,
          child: const Text(
            'All Rights Reserved © 2024, Supreme Court of India\nDeveloped by NIC for Supreme Court of India',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
