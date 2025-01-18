import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wereads/client/add_daily_activity.dart';

class DailyActivityList extends StatefulWidget {
  const DailyActivityList({super.key});

  @override
  _AdvocateListScreenState createState() => _AdvocateListScreenState();
}

class _AdvocateListScreenState extends State<DailyActivityList> {
  late Future<List<dynamic>> _advocateList;

  @override
  void initState() {
    super.initState();
    _advocateList = fetchAdvocates();
  }

  Future<List<dynamic>> fetchAdvocates() async {
    // Hardcoded demo values
    return [
      {
        'id': 1,
        'DATE': '2024-12-11',
        'CLIENT:MATTER': '456 Elm Street',
        'WORKED': '987-654-3210',
        'BILLABLE': 'janesmith@example.com',
        'CATEGORY/NOTES': 'dharwad',
      },
      {
        'id': 2,
        'DATE': '2024-12-12',
        'CLIENT:MATTER': '123 Maple Avenue',
        'WORKED': '123-456-7890',
        'BILLABLE': 'johndoe@example.com',
        'CATEGORY/NOTES': 'hubli',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'DAILY ACTIVITY LIST',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _advocateList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final advocate = data[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  elevation: 5.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    leading: const Icon(Icons.gavel, color: Colors.purple),
                    title: Text(
                      advocate['DATE'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CLIENT:MATTER: ${advocate['CLIENT:MATTER']}'),
                        Text('WORKED: ${advocate['WORKED']}'),
                        Text('BILLABLE: ${advocate['BILLABLE']}'),
                        Text('CATEGORY/NOTES: ${advocate['CATEGORY/NOTES']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdvocateEditScreen(
                                  arguments: advocate,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteAdvocate(advocate['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewactivityPage()),
          );
        },
        tooltip: 'DAILY ACTIVITY LIST',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> deleteAdvocate(int id) async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT/delete_advocate.php'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200 && response.body == '1') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advocate deleted successfully!')),
      );
      setState(() {
        _advocateList = fetchAdvocates(); // Refresh the list after deletion
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete advocate!')),
      );
    }
  }
}

class AdvocateEditScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const AdvocateEditScreen({super.key, required this.arguments});

  @override
  _AdvocateEditScreenState createState() => _AdvocateEditScreenState();
}

class _AdvocateEditScreenState extends State<AdvocateEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _dateController;
  late TextEditingController _clientController;
  late TextEditingController _workedController;
  late TextEditingController _billableController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    final args = widget.arguments;

    _dateController = TextEditingController(text: args['DATE']);
    _clientController = TextEditingController(text: args['CLIENT:MATTER']);
    _workedController = TextEditingController(text: args['WORKED']);
    _billableController = TextEditingController(text: args['BILLABLE']);
    _categoryController = TextEditingController(text: args['CATEGORY/NOTES']);
  }

  Future<void> updateAdvocate(int id) async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT/update_advocate.php'),
        body: {
          'id': id.toString(),
          'ad_name': _dateController.text,
          'ad_address': _clientController.text,
          'ad_phone': _workedController.text,
          'ad_mail': _billableController.text,
          'ad_address1': _categoryController.text,
        },
      );

      if (response.statusCode == 200 && response.body == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Advocate updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update advocate!')),
        );
      }
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = formatter.format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final advocateId = widget.arguments['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit DAILY ACTIVITY'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a date' : null,
              ),
              TextFormField(
                controller: _clientController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an address' : null,
              ),
              TextFormField(
                controller: _workedController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a phone number' : null,
              ),
              TextFormField(
                controller: _billableController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category/Notes'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter category or notes' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => updateAdvocate(advocateId),
                child: const Text('Update Advocate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
