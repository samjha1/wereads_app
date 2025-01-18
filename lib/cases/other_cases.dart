import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wereads/others/ADDLOKADALATROLES.dart';
import 'package:wereads/others/ADD_AMICUS_CURIAE.dart';
import 'package:wereads/others/ADD_COMMISSIONER.dart';
import 'package:wereads/others/ADD_NEW_LINKED.dart';
import 'package:wereads/others/appeal_add.dart';
import 'package:wereads/others/caveats_add.dart';
import 'package:wereads/others/legal_notie_add.dart';

class otherslistServices extends StatefulWidget {
  const otherslistServices({super.key});

  @override
  _OthersListServicesState createState() => _OthersListServicesState();
}

class _OthersListServicesState extends State<otherslistServices>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Fetch customer data from the API
  Future<List<Map<String, dynamic>>> fetchCustomerData(String tab) async {
    String apiUrl;

    // Change the API URL based on the selected tab
    if (tab == 'CAVEATS') {
      apiUrl =
          'https://api.indataai.in/wereads/caveats_list.php'; // Example API URL for INDIVIDUAL
    } else if (tab == 'LEGAL NOTICE') {
      apiUrl =
          'https://api.indataai.in/wereads/legal_list.php'; // Example API URL for COMPANY
    } else if (tab == 'APPEALS/OBJECTIONS') {
      apiUrl =
          'https://api.indataai.in/wereads/appeals_list.php'; // Example API URL for COMPANY
    } else if (tab == 'LOK ADALAT ROLES') {
      apiUrl =
          'https://api.indataai.in/wereads/fetch_companis.php'; // Example API URL for COMPANY
    } else if (tab == 'COURT COMMISSIONER ROLES') {
      apiUrl =
          'https://api.indataai.in/wereads/fetch_companis.php'; // Example API URL for COMPANY
    } else if (tab == 'AMICUS CURIAE') {
      apiUrl =
          'https://api.indataai.in/wereads/.php'; // Example API URL for COMPANY
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
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'OTHERS LIST',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.red,
          controller: _tabController,
          isScrollable: true, // Makes the tab bar scrollable for multiple tabs
          tabs: const [
            Tab(text: 'CAVEATS'),
            Tab(text: 'LEGAL NOTICE'),
            Tab(text: 'APPEALS/OBJECTIONS'),
            Tab(text: 'LOK ADALAT ROLES'),
            Tab(text: 'COURT COMMISSIONER ROLES'),
            Tab(text: 'AMICUS CURIAE'),
            Tab(text: 'LINKED ASSIGNMENT'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent('CAVEATS'),
          _buildTabContent('LEGAL NOTICE'),
          _buildTabContent('APPEALS/OBJECTIONS'),
          _buildTabContent('LOK ADALAT ROLES'),
          _buildTabContent('COURT COMMISSIONER ROLES'),
          _buildTabContent('AMICUS CURIAE'),
          _buildTabContent('LINKED ASSIGNMENT'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            // Assuming CAVEATS is the first tab
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CaveatsForm(), // Replace with your desired page
              ),
            );
          } else if (_tabController.index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddLegalNoticesPage(), // Replace with your desired page
              ),
            );
          } else if (_tabController.index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddAppealsObjections(), // Replace with your desired page
              ),
            );
          } else if (_tabController.index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Addlokadalatroles(), // Replace with your desired page
              ),
            );
          } else if (_tabController.index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddCommissioner(), // Replace with your desired page
              ),
            );
          } else if (_tabController.index == 5) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddAmicusCuriae(), // Replace with your desired page
              ),
            );
          } else if (_tabController.index == 6) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddNewLinked(), // Replace with your desired page
              ),
            );
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper method to build content for each tab
  Widget _buildTabContent(String tabName) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCustomerData(tabName),
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
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(entry['client_name'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Party Name: ${entry['party_name'] ?? ''}'),
                      Text('court: ${entry['court'] ?? ''}'),
                    ],
                  ),
                  onTap: () {
                    // Navigate to details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailPage(entry: entry),
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

  const CustomerDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          entry['client_name'] ?? 'Customer Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Client Name: ${entry['client_name'] ?? ''}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('party name: ${entry['party_name'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('court: ${entry['court'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('court hall: ${entry['court_hall'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('case number: ${entry['case_number'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('case year : ${entry['case_year'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            Text('title  : ${entry['title1'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            ElevatedButton(
              onPressed: () async {
                final updatedEntry = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCustomerPage(entry: entry),
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

  const EditCustomerPage({super.key, required this.entry});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  late TextEditingController clientNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController purposeController;
  late TextEditingController advocateController;

  @override
  void initState() {
    super.initState();
    clientNameController = TextEditingController(text: widget.entry['fname']);
    phoneController = TextEditingController(text: widget.entry['phone']);
    emailController = TextEditingController(text: widget.entry['mail']);
    addressController = TextEditingController(text: widget.entry['address']);
    purposeController = TextEditingController(text: widget.entry['purpose']);
    advocateController = TextEditingController(text: widget.entry['advocate']);
  }

  @override
  void dispose() {
    clientNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    purposeController.dispose();
    advocateController.dispose();

    super.dispose();
  }

  Future<void> updateCustomer() async {
    final updatedEntry = {
      'id': widget.entry['id'].toString(), // Ensure ID is a string
      'client_name': clientNameController.text,
      'phone': phoneController.text,
      'mail_id': emailController.text,
      'address': addressController.text,
      'city': purposeController.text,
      'state': advocateController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://api.indataai.in/wereads/edit_client.php'),
        body: updatedEntry,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          Navigator.pop(context, updatedEntry);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Customer details updated successfully.')),
          );
        } else {
          throw Exception(responseBody['message']);
        }
      } else {
        throw Exception(
            'Failed to update customer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: clientNameController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: purposeController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: advocateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Call the update function and wait for the result
                await updateCustomer();

                // After updating, navigate to a new page (for example, a confirmation or next screen)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddcorparateModal(), // Replace NewPage with your desired page
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddcorparateModal extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form inputs
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController partyNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commiDateController = TextEditingController();
  final TextEditingController compDateController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController advocateNameController = TextEditingController();
  final TextEditingController oAdvocateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController actionDateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  AddcorparateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('OTHERS list'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Client Name Dropdown (for selection)
              DropdownButtonFormField<String>(
                value: null,
                hint: const Text('Select Items'),
                onChanged: (value) {},
                items: const [
                  DropdownMenuItem(
                    value: 'Item 1',
                    child: Text('Item 1'),
                  ),
                  DropdownMenuItem(
                    value: 'Item 2',
                    child: Text('Item 2'),
                  ),
                  // Add more items here
                ],
                decoration: const InputDecoration(labelText: 'Client Name*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a client';
                  }
                  return null;
                },
              ),
              // Party Name Input
              TextFormField(
                controller: partyNameController,
                decoration: const InputDecoration(labelText: 'Your Party Name'),
              ),
              // Title Input
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              // Date of Commitments Input
              TextFormField(
                controller: commiDateController,
                decoration:
                    const InputDecoration(labelText: 'Date of Commitments'),
                keyboardType: TextInputType.datetime,
              ),
              // Date of Completion Input
              TextFormField(
                controller: compDateController,
                decoration:
                    const InputDecoration(labelText: 'Date of Completion'),
                keyboardType: TextInputType.datetime,
              ),
              // Priority Input
              TextFormField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              // Advocate Name Input
              TextFormField(
                controller: advocateNameController,
                decoration: const InputDecoration(labelText: 'Advocate Name#'),
              ),
              // Opposite Advocate Name Input
              TextFormField(
                controller: oAdvocateController,
                decoration:
                    const InputDecoration(labelText: 'Opposite Advocate Name#'),
              ),
              // Phone Input with validation
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Mobile No.'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.length != 10) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              // Action Date Input
              TextFormField(
                controller: actionDateController,
                decoration: const InputDecoration(labelText: 'Action Date'),
                keyboardType: TextInputType.datetime,
              ),
              // Status Input
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              // Remarks Input
              TextFormField(
                controller: remarksController,
                decoration: const InputDecoration(labelText: 'Remarks'),
              ),
              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      Navigator.of(context).pop(); // Close the modal
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the modal
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class CaseFormPage extends StatefulWidget {
  const CaseFormPage({super.key});

  @override
  _CaseFormPageState createState() => _CaseFormPageState();
}

class _CaseFormPageState extends State<CaseFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form fields
  String clientName = '';
  String court = '';
  String courtHall = '';
  String caseType = '';
  String caseNumber = '';
  String caseYear = '';
  String partyName = '';
  String oppositePartyName = '';
  String title = '';

  // Message display
  String msg = '';

  // Handle form submission
  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('your-backend-url/ajax.php?action=save_offline_case'),
        body: {
          'client_name': clientName,
          'court': court,
          'court_hall': courtHall,
          'case_type': caseType,
          'case_number': caseNumber,
          'case_year': caseYear,
          'party_name': partyName,
          'o_party': oppositePartyName,
          'title1': title,
        },
      );

      if (response.statusCode == 200) {
        var resp = response.body;
        if (resp == '1') {
          setState(() {
            msg = 'Data successfully saved';
          });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/offline_case_list');
          });
        } else {
          setState(() {
            msg = 'Error occurred. Try again!';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Offline Case Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildFormField(
                  label: 'Client Name',
                  onChanged: (value) => clientName = value,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the client name';
                    }
                    return null;
                  },
                ),
                buildFormField(
                  label: 'Court',
                  onChanged: (value) => court = value,
                ),
                buildFormField(
                  label: 'Court Hall/Room#',
                  onChanged: (value) => courtHall = value,
                ),
                buildFormField(
                  label: 'Case Type',
                  onChanged: (value) => caseType = value,
                ),
                buildFormField(
                  label: 'Case Number',
                  onChanged: (value) => caseNumber = value,
                ),
                buildFormField(
                  label: 'Case Year',
                  onChanged: (value) => caseYear = value,
                ),
                buildFormField(
                  label: 'Your Party Name',
                  onChanged: (value) => partyName = value,
                ),
                buildFormField(
                  label: 'Opposite Party Name',
                  onChanged: (value) => oppositePartyName = value,
                ),
                buildFormField(
                  label: 'Title',
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 20),
                if (msg.isNotEmpty)
                  Text(
                    msg,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text('Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/offline_case_list');
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormField({
    required String label,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
