import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wereads/client/client.dart';
import 'package:wereads/client/clientcompany.dart';
import 'package:wereads/client/clientothers.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Fetch customer data from the API
  Future<List<Map<String, dynamic>>> fetchCustomerData(String tab) async {
    String apiUrl;

    // Change the API URL based on the selected tab
    if (tab == 'INDIVIDUAL') {
      apiUrl =
          'https://api.indataai.in/wereads/fetch_customers.php'; // Example API URL for INDIVIDUAL
    } else if (tab == 'COMPANY') {
      apiUrl =
          'https://api.indataai.in/wereads/fetch_companies.php'; // Example API URL for COMPANY
    } else {
      apiUrl =
          'https://api.indataai.in/wereads/fetch_others.php'; // Example API URL for OTHERS
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('CLIENT LIST', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: 'INDIVIDUAL'),
            Tab(text: 'COMPANY'),
            Tab(text: 'OTHERS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab content for INDIVIDUAL
          TabContent(
            tab: 'INDIVIDUAL',
            fetchCustomerData: fetchCustomerData,
          ),
          // Tab content for COMPANY
          TabContent(
            tab: 'COMPANY',
            fetchCustomerData: fetchCustomerData,
          ),
          // Tab content for OTHERS
          TabContent(
            tab: 'OTHERS',
            fetchCustomerData: fetchCustomerData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Widget screen;
          if (_tabController.index == 0) {
            screen = const ClientScreen();
          } else if (_tabController.index == 1) {
            screen = const CompanyScreen();
          } else {
            screen = const OtherScreen();
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TabContent extends StatelessWidget {
  final String tab;
  final Future<List<Map<String, dynamic>>> Function(String tab)
      fetchCustomerData;

  const TabContent(
      {super.key, required this.tab, required this.fetchCustomerData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCustomerData(tab), // Fetch data based on selected tab
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final customerList = snapshot.data!;
          return ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (context, index) {
              final entry = customerList[index];
              return Card(
                margin: const EdgeInsets.all(10.0),
                elevation: 5.0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15.0),
                  leading: const Icon(Icons.person,
                      color:
                          Colors.blue), // Use for both INDIVIDUAL and COMPANY
                  title: Text(
                    tab == 'INDIVIDUAL'
                        ? (entry['client_name'] ?? 'No Client Name')
                        : tab == 'COMPANY'
                            ? (entry['company_name'] ?? 'No Company Name')
                            : (entry['o_name'] ?? 'No  Name'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tab == 'INDIVIDUAL'
                            ? 'Phone: ${entry['ph'] ?? 'No Phone'}'
                            : tab == 'COMPANY'
                                ? (entry['ph1'] ?? 'No Company Name')
                                : (entry['o_ph'] ?? 'No  Name'),
                      ),
                      Text(
                        tab == 'INDIVIDUAL'
                            ? 'Email: ${entry['mail'] ?? 'No Email'}'
                            : tab == 'COMPANY'
                                ? 'Email: ${entry['mail1'] ?? 'No Email'}'
                                : 'Email: ${entry['o_mail'] ?? 'No Email'}',
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerDetailPage(entry: entry, tab: tab),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CustomerDetailPage extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String tab; // Add tab to distinguish between INDIVIDUAL and COMPANY

  const CustomerDetailPage({super.key, required this.entry, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          tab == 'INDIVIDUAL'
              ? (entry['client_name'] ?? 'Client Details')
              : (entry['company_name'] ?? 'Company Details'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              tab == 'INDIVIDUAL'
                  ? 'Name: ${entry['client_name'] ?? ''}'
                  : 'Company Name: ${entry['company_name'] ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              tab == 'INDIVIDUAL'
                  ? 'Phone: ${entry['ph'] ?? ''}'
                  : 'Phone: ${entry['ph1'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              tab == 'INDIVIDUAL'
                  ? 'Email: ${entry['mail'] ?? ''}'
                  : 'Email: ${entry['mail1'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              tab == 'INDIVIDUAL'
                  ? 'Address: ${entry['address'] ?? ''}'
                  : 'Address: ${entry['address1'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              tab == 'INDIVIDUAL'
                  ? 'State: ${entry['state'] ?? ''}'
                  : 'State: ${entry['state1'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              tab == 'INDIVIDUAL'
                  ? 'City: ${entry['city'] ?? ''}'
                  : 'City: ${entry['city1'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              tab == 'INDIVIDUAL'
                  ? 'ZIP Code: ${entry['zcode'] ?? ''}'
                  : 'ZIP Code: ${entry['zcode1'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final updatedEntry = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditCustomerPage(entry: entry, tab: tab),
                  ),
                );

                if (updatedEntry != null) {
                  // Handle updated data, e.g., refresh the page or update the UI
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Customer details updated successfully.')),
                  );
                }
              },
              child: const Text('Edit Case'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditCustomerPage extends StatefulWidget {
  final Map<String, dynamic> entry;

  const EditCustomerPage({super.key, required this.entry, required String tab});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  // Define TextEditingControllers
  late TextEditingController clientNameController;
  late TextEditingController CONTACTTYPEController;
  late TextEditingController ADDRESSController;
  late TextEditingController STATEController;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;
  late TextEditingController EMAILController;
  late TextEditingController MOBILEController;
  late TextEditingController SOCIALController;
  late TextEditingController PANController;
  late TextEditingController TANController;
  late TextEditingController WEBSITEController;
  late TextEditingController SUBCATEGORYController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values from the entry map
    clientNameController =
        TextEditingController(text: widget.entry['client_name'] ?? '');
    CONTACTTYPEController =
        TextEditingController(text: widget.entry['contact_type'] ?? '');
    ADDRESSController =
        TextEditingController(text: widget.entry['address'] ?? '');
    STATEController = TextEditingController(text: widget.entry['state'] ?? '');
    cityController = TextEditingController(text: widget.entry['city'] ?? '');
    zipCodeController =
        TextEditingController(text: widget.entry['zcode'] ?? '');
    EMAILController = TextEditingController(text: widget.entry['mail'] ?? '');
    MOBILEController = TextEditingController(text: widget.entry['ph'] ?? '');
    SOCIALController =
        TextEditingController(text: widget.entry['social'] ?? '');
    PANController = TextEditingController(text: widget.entry['pan'] ?? '');
    TANController = TextEditingController(text: widget.entry['tan'] ?? '');
    WEBSITEController =
        TextEditingController(text: widget.entry['website'] ?? '');
    SUBCATEGORYController =
        TextEditingController(text: widget.entry['subcategory'] ?? '');
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    clientNameController.dispose();
    CONTACTTYPEController.dispose();
    ADDRESSController.dispose();
    STATEController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    EMAILController.dispose();
    MOBILEController.dispose();
    SOCIALController.dispose();
    PANController.dispose();
    TANController.dispose();
    WEBSITEController.dispose();
    SUBCATEGORYController.dispose();
    super.dispose();
  }

  Future<void> updateCustomerInDatabase(
      Map<String, dynamic> updatedData) async {
    const apiUrl = 'https://api.indataai.in/wereads/customersupdate.php';

    try {
      // Ensure all values are strings before sending the request
      final updatedDataString = {
        'id': updatedData['id']
            .toString(), // Convert 'id' to string if it's an int
        'client_name': updatedData['client_name'].toString(),
        'contact_type': updatedData['contact_type'].toString(),
        'address': updatedData['address'].toString(),
        'state': updatedData['state'].toString(),
        'city': updatedData['city'].toString(),
        'zcode': updatedData['zcode'].toString(),
        'mail': updatedData['mail'].toString(),
        'ph': updatedData['ph'].toString(),
        'social': updatedData['social'].toString(),
        'pan': updatedData['pan'].toString(),
        'tan': updatedData['tan'].toString(),
        'website': updatedData['website'].toString(),
        'subcategory': updatedData['subcategory'].toString(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: updatedDataString,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer updated successfully!')),
        );
        Navigator.pop(context, updatedData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update customer. Error: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating customer: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: clientNameController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            TextField(
              controller: CONTACTTYPEController,
              decoration: const InputDecoration(labelText: 'Contact Type'),
            ),
            TextField(
              controller: ADDRESSController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: STATEController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: zipCodeController,
              decoration: const InputDecoration(labelText: 'Zip Code'),
            ),
            TextField(
              controller: EMAILController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: MOBILEController,
              decoration: const InputDecoration(labelText: 'Mobile'),
            ),
            TextField(
              controller: SOCIALController,
              decoration: const InputDecoration(labelText: 'Social Profile'),
            ),
            TextField(
              controller: PANController,
              decoration: const InputDecoration(labelText: 'PAN'),
            ),
            TextField(
              controller: TANController,
              decoration: const InputDecoration(labelText: 'TAN'),
            ),
            TextField(
              controller: WEBSITEController,
              decoration: const InputDecoration(labelText: 'Website'),
            ),
            TextField(
              controller: SUBCATEGORYController,
              decoration: const InputDecoration(labelText: 'Subcategory'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  'id': widget.entry['id'], // Include the ID in the data
                  'client_name': clientNameController.text,
                  'contact_type': CONTACTTYPEController.text,
                  'address': ADDRESSController.text,
                  'state': STATEController.text,
                  'city': cityController.text,
                  'zcode': zipCodeController.text,
                  'mail': EMAILController.text,
                  'ph': MOBILEController.text,
                  'social': SOCIALController.text,
                  'pan': PANController.text,
                  'tan': TANController.text,
                  'website': WEBSITEController.text,
                  'subcategory': SUBCATEGORYController.text,
                };

                updateCustomerInDatabase(updatedData);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
