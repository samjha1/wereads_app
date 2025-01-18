import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wereads/cases/offline_case_add.dart';
import 'package:wereads/cases/other_cases.dart';
import 'package:wereads/nonlitigation/INTELLECTUAl_list.dart';
import 'package:wereads/nonlitigation/Liaisoning_list.dart';
import 'package:wereads/nonlitigation/MSMElist.dart';
import 'dart:convert';
import 'package:wereads/cases/add_litigation.dart';
import 'package:wereads/nonlitigation/REALESTATElist.dart';
import 'package:wereads/nonlitigation/corporate_list.dart';
import 'package:wereads/nonlitigation/cyber_list.dart';
import 'package:wereads/nonlitigation/taxlist.dart';
import 'package:wereads/sidebar.dart';

class LitigationPage extends StatelessWidget {
  const LitigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of services
    final services = [
      "MATTERS",
      "OFFLINE CASES",
      "OTHERS CASES",
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          textAlign: TextAlign.left,
          "Litigation Matters",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15.0),
                title: Text(
                  services[index],
                  style: const TextStyle(fontSize: 16.0),
                ),
                leading: const Icon(
                  Icons.radio_button_off, // Circle icon
                  color: Colors.grey,
                ),
                onTap: () {
                  // Navigate to the ServiceDetailPage and pass the service name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => services[index] == "MATTERS"
                          ? const Matterspage()
                          : services[index] == "OFFLINE CASES"
                              ? const offlinelistServices()
                              : services[index] == "OTHERS CASES"
                                  ? const otherslistServices()
                                  : ServiceDetailPage(
                                      service: services[index],
                                    ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Matterspage extends StatefulWidget {
  const Matterspage({super.key});

  @override
  _LitigationPageState createState() => _LitigationPageState();
}

class _LitigationPageState extends State<Matterspage> {
  // Function to fetch data from the API
  Future<List<Map<String, dynamic>>> fetchLitigationData() async {
    final response = await http
        .get(Uri.parse('https://api.indataai.in/wereads/litigation_list.php'));

    if (response.statusCode == 200) {
      // Parse the response body as JSON
      List<dynamic> data = json.decode(response.body);
      // Convert the data to a List of Map
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load litigation data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Litigation Matters",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchLitigationData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final litigationList = snapshot.data!;
              return ListView.builder(
                itemCount: litigationList.length,
                itemBuilder: (context, index) {
                  final entry = litigationList[index];
                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 5.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15.0),
                      leading: const Icon(
                        Icons.gavel,
                        color: Colors.purple,
                      ), // Gavel icon
                      title: Text(entry['client_name'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Court: ${entry['court'] ?? ''}'),
                          Text('Phone: ${entry['phone'] ?? ''}'),
                        ],
                      ),
                      onTap: () {
                        // Navigate to detail page with all fields
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CaseDetailPage(entry: entry),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new page (for example, NewCasePage)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const NewCasePage(), // Replace with your desired page
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // "+" icon
      ),
    );
  }
}

class CaseDetailPage extends StatelessWidget {
  final Map<String, dynamic> entry;

  const CaseDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        // Wrap the content in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Name: ${entry['client_name'] ?? ''}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('COURTS/TRIBUNAL: ${entry['court'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('High Court: ${entry['high_court'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Court Hall/Room#: ${entry['court_hall'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Case Type: ${entry['case_type'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Case Number: ${entry['case_number'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Case Year: ${entry['case_year'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('YOUR PARTY NAME: ${entry['party_name'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('OPPOSITE PARTY NAME: ${entry['o_party'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('TITLE: ${entry['title'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('DATE OF FILLING: ${entry['date_filling'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('PREVIOUS HEARING DATE: ${entry['last_hear_dt'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('PREVIOUS STAGE: ${entry['stage1'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('NEXT HEARING DATE: ${entry['hearing_dt'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('NEXT HEARING STAGE: ${entry['stage2'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('HEARING JUDGE NAME: ${entry['judge_name'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('FIR NUMBER: ${entry['fir_no'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('FIR YEAR: ${entry['fir_year'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('POLICE STATION: ${entry['fir_police_station'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('PRIORITY: ${entry['priority'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Advocate Name: ${entry['advocate_name'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('OPPOSITE ADVOCATE NAME: ${entry['o_advocate'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('CASE SUMMARY UPLOAD: ${entry['summary'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('PHONE NO: ${entry['ph'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Description: ${entry['note_box'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            ElevatedButton(
              onPressed: () {
                // Optionally add more actions (like edit, delete) here
              },
              child: const Text('Edit Case'),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayCasesPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TodayCasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Matters',
            style: TextStyle(fontWeight: FontWeight.w100, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                _scaffoldKey.currentState
                    ?.openEndDrawer(); // Open the right-side drawer
              },
            ),
          ],
        ),
        endDrawer:
            const SideBar(), // This makes the drawer appear on the right side
        body: Container(
          color: Colors.white,
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Welcome to Matters Page',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'LITIGATION LIST'),
                  Tab(text: 'NON LITIGATION'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    LitigationPage(),
                    nonLitigationPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class nonLitigationPage extends StatelessWidget {
  const nonLitigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of services
    final services = [
      "Corporate Legal Services",
      "Real Estate Legal Services",
      "Tax Advisory Services",
      "Cyber Laws and Digital Services",
      "MSME and Business Advisory",
      "Intellectual Property (IP) Services",
      "Liaisoning Services",
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          textAlign: TextAlign.left,
          "Non Litigation Matters",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15.0),
                title: Text(
                  services[index],
                  style: const TextStyle(fontSize: 16.0),
                ),
                leading: const Icon(
                  Icons.radio_button_off, // Circle icon
                  color: Colors.grey,
                ),
                onTap: () {
                  // Navigate to the ServiceDetailPage and pass the service name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => services[index] ==
                              "Corporate Legal Services"
                          ? const CorporateLegalServices()
                          : services[index] == "Real Estate Legal Services"
                              ? const Realestatelist()
                              : services[index] == "Tax Advisory Services"
                                  ? const Taxlist()
                                  : services[index] ==
                                          "Cyber Laws and Digital Services"
                                      ? const CyberList()
                                      : services[index] ==
                                              "MSME and Business Advisory"
                                          ? const Msmelist()
                                          : services[index] ==
                                                  "Intellectual Property (IP) Services"
                                              ? const Intellectul_list()
                                              : services[index] ==
                                                      "Liaisoning Services"
                                                  ? const LiaisoningList()
                                                  : ServiceDetailPage(
                                                      service: services[index],
                                                    ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Service Detail Page to display the service details
class ServiceDetailPage extends StatelessWidget {
  final String service;

  const ServiceDetailPage({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Details for $service', // Customize this based on your need
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
