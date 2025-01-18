import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class todolist extends StatelessWidget {
  const todolist({super.key});

  // Fetch customer data from the API
  Future<List<Map<String, dynamic>>> fetchCustomerData() async {
    const apiUrl =
        'https://api.indataai.in/wereads/todo_list.php'; // Replace with your API URL

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
          'TODO LIST',
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
                          Text('title: ${entry['title'] ?? ''}'),
                          Text('firstname: ${entry['firstname'] ?? ''}'),
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
              builder: (context) =>
                  EstimateFormPage(), // Replace with your desired page
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
            Text('priority: ${entry['priority'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('first name: ${entry['firstname'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('court hall: ${entry['court_hall'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('note box: ${entry['note_box'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('case year : ${entry['case_year'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            Text('a_date  : ${entry['a_date'] ?? ''}',
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
                        EstimateFormPage(), // Replace NewPage with your desired page
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

class EstimateFormPage extends StatefulWidget {
  const EstimateFormPage({super.key});

  @override
  _EstimateFormPageState createState() => _EstimateFormPageState();
}

class _EstimateFormPageState extends State<EstimateFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _caseTypeController = TextEditingController();
  final TextEditingController _caseNoController = TextEditingController();
  final TextEditingController _assignedDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? selectedClient;
  String? selectedTitle;
  String? selectedPriority;
  String? selectedAssignTo;

  List<String> clients = [];
  List<String> titles = [];

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.indataai.in/wereads/fetch_caseclinetname.php'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          clients = List<String>.from(data);
        });
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching clients: $e')),
      );
    }
  }

  Future<void> _fetchTitles(String clientName) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.indataai.in/wereads/fetch_caseclinetname.php?client_name=$clientName'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          titles = List<String>.from(data);
        });
      } else {
        throw Exception('Failed to load titles');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching titles: $e')),
      );
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _saveEstimate() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving estimate...')),
      );
      // Add your API call logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Estimate Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedClient,
                onChanged: (value) {
                  setState(() {
                    selectedClient = value;
                  });
                  if (value != null) _fetchTitles(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Client Name*',
                  border: OutlineInputBorder(),
                ),
                items: clients.map((client) {
                  return DropdownMenuItem<String>(
                    value: client,
                    child: Text(client),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a client' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedTitle,
                onChanged: (value) {
                  setState(() {
                    selectedTitle = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Title*',
                  border: OutlineInputBorder(),
                ),
                items: titles.map((title) {
                  return DropdownMenuItem<String>(
                    value: title,
                    child: Text(title),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caseTypeController,
                decoration: const InputDecoration(
                  labelText: 'Case Type',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caseNoController,
                decoration: const InputDecoration(
                  labelText: 'Case Number',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _assignedDateController,
                decoration: InputDecoration(
                  labelText: 'Assigned Date*',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(_assignedDateController),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter assigned date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date*',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(_dueDateController),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter due date' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Priority*',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Urgent',
                  'High',
                  'Medium',
                  'Low',
                ].map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Row(
                      children: [
                        Icon(
                          priority == 'Urgent'
                              ? Icons.error
                              : priority == 'High'
                                  ? Icons.priority_high
                                  : Icons.low_priority,
                          color: priority == 'Urgent'
                              ? Colors.red
                              : priority == 'High'
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(priority),
                      ],
                    ),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select priority' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveEstimate,
                    child: const Text('Save'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
