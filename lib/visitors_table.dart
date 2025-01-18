import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wereads/visitors.dart';

class VisitorsScreen extends StatelessWidget {
  const VisitorsScreen({super.key});

  // Fetch customer data from the API
  Future<List<Map<String, dynamic>>> fetchCustomerData() async {
    const apiUrl =
        'https://api.indataai.in/wereads/visitorslist.php'; // Replace with your API URL

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Visitors List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCustomerData(),
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
                    title: Text(entry['fname'] ?? ''),
                    subtitle: Text('Phone: ${entry['phone'] ?? ''}'),
                    onTap: () {
                      // Navigate to details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CustomerDetailPage(entry: entry),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new page (for example, NewCasePage)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const Visitors(), // Replace with your desired page
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
          entry['fname'] ?? 'Customer Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Client Name: ${entry['fname'] ?? ''}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Phone: ${entry['phone'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Email: ${entry['mail'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Address: ${entry['address'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('purpose: ${entry['purpose'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('CONCERN ADVOCATE : ${entry['advocate'] ?? ''}',
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
                        const Visitors(), // Replace NewPage with your desired page
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
