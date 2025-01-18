import 'package:flutter/material.dart';
import 'package:wereads/post/POST_LIST.dart';
import 'fetchdairy_records.dart';
import 'sidebar.dart';
import 'visitors_table.dart' as visitorsTable;
import 'dairyScreen.dart';
import 'SiteBooking.dart';
import 'package:wereads/NotificationPage.dart';

class ReceptionDashboard extends StatefulWidget {
  const ReceptionDashboard({super.key});

  @override
  State<ReceptionDashboard> createState() => _ReceptionDashboardState();
}

class _ReceptionDashboardState extends State<ReceptionDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'ILP LAW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          _buildNotificationButton(),
          _buildProfileButton(),
        ],
      ),
      drawer: const SideBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildHeadlineSection(),

            _buildStatsBar(),
            Expanded(
              child: _buildDashboardGrid(),
            ),
            _buildFooter(), // Add footer here
          ],
        ),
      ),
    );
  }

  Widget _buildHeadlineSection() {
    return Container(
      width: double.infinity, // Ensures the container takes the full width
      padding:
          const EdgeInsets.fromLTRB(15, 10, 0, 0), // Adjust padding as needed
      color: Colors.white, // You can choose another color if needed.
      child: const Align(
        alignment: Alignment.centerLeft, // Aligns the text to the left
        child: Text(
          'Welcome to ILP Reception',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign:
              TextAlign.center, // Ensures text alignment inside its container
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications_none_rounded, size: 30),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPages()),
        ),
      ),
    );
  }

  Widget _buildProfileButton() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('assets/images/SAM.jpeg'),
          ),
        ),
        onPressed: () {
          // Add profile action
        },
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Active Cases', '124', Icons.gavel_rounded),
          _buildStatItem('Appointments', '8', Icons.event),
          _buildStatItem('Documents', '463', Icons.description),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardGrid() {
    final List<DashboardItemData> items = [
      DashboardItemData(
        icon: Icons.question_mark_rounded,
        label: 'Visitors',
        color: Theme.of(context).primaryColor,
        description: '',
        route: const visitorsTable.VisitorsScreen(),
      ),
      DashboardItemData(
        icon: Icons.article_rounded,
        label: 'Post',
        color: Theme.of(context).primaryColor,
        description: '',
        route: const RegisterpostList(),
      ),
      DashboardItemData(
        icon: Icons.book_rounded,
        label: 'Diary',
        color: Theme.of(context).primaryColor,
        description: '',
        route: const DairyScreen(),
      ),
      DashboardItemData(
        icon: Icons.visibility_rounded,
        label: 'Diary List',
        color: Theme.of(context).primaryColor,
        description: '',
        route: const fetchdairy_records(),
      ),
      DashboardItemData(
        icon: Icons.calendar_month_rounded,
        label: 'Site Booking',
        color: Theme.of(context).primaryColor,
        description: '',
        route: const SiteBookingPage(),
      ),
      DashboardItemData(
        icon: Icons.share_rounded,
        label: 'Social Media',
        color: Theme.of(context).primaryColor,
        description: '',
        route: null,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Increase the number of items in a row
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 0.8, // Adjust aspect ratio to make items shorter
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildDashboardItem(items[index]),
    );
  }

  Widget _buildDashboardItem(DashboardItemData item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 12,
      shadowColor: item.color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          if (item.route != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item.route!),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.color.withOpacity(0.5),
                      width: 5,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    size: 39,
                    color: item.color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardItemData {
  final IconData icon;
  final String label;
  final Color color;
  final String description;
  final Widget? route;

  DashboardItemData({
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
    this.route,
  });
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
