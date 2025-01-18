import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Addlokadalatroles extends StatefulWidget {
  @override
  _AddLegalNoticesPageState createState() => _AddLegalNoticesPageState();
}

class _AddLegalNoticesPageState extends State<Addlokadalatroles> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields

  TextEditingController fillingDateController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController courtTypeController = TextEditingController();
  TextEditingController actionDateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController partyNameController =
      TextEditingController(); // Added this controller

  // Function to handle date selection for filling date and expiry date

  // Example function for fetching client details
  Future<void> getClientDetails(String clientId) async {
    final response = await http.post(
      Uri.parse('https://your-backend-api-url/caveats_case.php'),
      body: {'tmp_id': clientId},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        partyNameController.text = data['party_name'] ?? '';
        // Continue with other fields like phone, address, etc.
      });
    } else {
      print("Failed to load client details");
    }
  }

  // Handle form submission
  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('https://your-backend-api-url/ajax.php?action=save_others'),
        body: {
          'client_name': clientNameController.text,
          'party_name': partyNameController.text,
          'filling_dt': fillingDateController.text, // Corrected this line
          'expiry_dt': expiryDateController.text, // Corrected this line
          'purpose': purposeController.text,
          'court_type': courtTypeController.text,
          'action_dt1': actionDateController.text,
          'remarks1': remarksController.text,
          'status1': statusController.text,
          'roleSelector': 'caveats',
        },
      );

      if (response.statusCode == 200) {
        final resp = response.body;
        if (resp == '1') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data successfully saved')));
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/others_case_list');
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
              content: Text("Something went wrong: $resp"),
            ),
          );
        }
      } else {
        print("Failed to submit form");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'ADD LOKADALAT ROLES',
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Client Name
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Client Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: clientNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Client Name',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a client' : null,
              ),
              const SizedBox(height: 15),

              // Party Name
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Party Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: partyNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Party Name',
                ),
              ),
              const SizedBox(height: 15),
// Filling Date
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Filling DATE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: fillingDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Date',
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: fillingDateController.text.isNotEmpty
                        ? DateTime.parse(fillingDateController.text)
                        : DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      // Formatting the date to only include the date (no time)
                      fillingDateController.text =
                          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
              ),
              const SizedBox(height: 15),

// Expiry Date
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'EXPIRY DATE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: expiryDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Date',
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: expiryDateController.text.isNotEmpty
                        ? DateTime.parse(expiryDateController.text)
                        : DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      // Formatting the date to only include the date (no time)
                      expiryDateController.text =
                          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
              ),
              const SizedBox(height: 15),

              // Purpose

              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Purpose',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: purposeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Purpose',
                ),
              ),
              const SizedBox(height: 15),

              // Court Type
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Court Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: courtTypeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Court Type',
                ),
              ),
              const SizedBox(height: 15),

              // Action Date
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Action Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: actionDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Select Action Date',
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: actionDateController.text.isNotEmpty
                        ? DateTime.parse(actionDateController.text)
                        : DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      actionDateController.text =
                          selectedDate.toIso8601String();
                    });
                  }
                },
              ),
              const SizedBox(height: 15),

              // Remarks
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Remarks',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: remarksController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Remarks',
                ),
              ),
              const SizedBox(height: 15),

              // Status
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  hintText: 'Enter Status',
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),

              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/others_case_list');
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
