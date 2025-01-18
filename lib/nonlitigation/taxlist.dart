import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wereads/nonlitigation/tax_add.dart';

class Taxlist extends StatelessWidget {
  const Taxlist({super.key});

  // Fetch customer data from the API
  Future<List<Map<String, dynamic>>> fetchCustomerData() async {
    const apiUrl =
        'https://api.indataai.in/wereads/tax_list.php'; // Replace with your API URL

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
          'TAX ADVISORY SERVICES',
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
                    title: Text(entry['client_name'] ?? ''),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Party Name: ${entry['party_name'] ?? ''}'),
                          Text('Title: ${entry['title'] ?? ''}'),
                        ]),
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
              builder: (context) => taxform(), // Replace with your desired page
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
            Text('title: ${entry['title'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Address: ${entry['commi_dt'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('purpose: ${entry['priority'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Advocate Name : ${entry['advocate_name'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            Text('PHONE : ${entry['phone'] ?? ''}',
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
      title: const Text('Add New Corporate Legal Services'),
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
