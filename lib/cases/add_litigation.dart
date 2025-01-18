// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewCasePage extends StatefulWidget {
  const NewCasePage({super.key});

  @override
  _NewCasePageState createState() => _NewCasePageState();
}

class _NewCasePageState extends State<NewCasePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    // Define all fields
    final fields = [
      'court',
      'high_court',
      'court_hall',
      'case_type',
      'case_number',
      'case_year',
      'party_name',
      'o_party',
      'title',
      'date_filling',
      'last_hear_dt',
      'stage1',
      'hearing_dt',
      'stage2',
      'judge_name',
      'fir_no',
      'fir_year',
      'fir_police_station',
      'priority',
      'advocate_name',
      'o_advocate',
      'summary',
      'ph',
      'note_box',
    ];

    // Initialize controllers for all fields
    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Collect form data
      final formData =
          _controllers.map((key, controller) => MapEntry(key, controller.text));

      try {
        final url = Uri.parse('https://api.indataai.in/wereads/litigation.php');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json', // Specify JSON format
          },
          body: jsonEncode(formData), // Encode form data as JSON
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData['error'] != null) {
            _showSnackBar(responseData['error'], Colors.red);
          } else if (responseData['message'] != null) {
            _showSnackBar(responseData['message'], Colors.green);
          } else {
            _showSnackBar('Unexpected response from the server', Colors.orange);
          }
        } else {
          _showSnackBar('Server error: ${response.statusCode}', Colors.red);
        }
      } catch (e) {
        _showSnackBar('Error: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Add New Case', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ..._buildFormFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final fieldLabels = {
      'court': 'COURTS/TRIBUNAL',
      'high_court': 'High Court',
      'court_hall': 'Court Hall/Room#',
      'case_type': 'Case Type',
      'case_number': 'Case Number',
      'case_year': 'Case Year',
      'party_name': 'YOUR PARTY NAME',
      'o_party': 'OPPOSITE PARTY NAME',
      'title': 'TITLE',
      'date_filling': 'DATE OF FILLING',
      'last_hear_dt': 'PREVIOUS HEARING DATE',
      'stage1': 'PREVIOUS STAGE',
      'hearing_dt': 'NEXT HEARING DATE',
      'stage2': 'NEXT HEARING STAGE',
      'judge_name': 'HEARING JUDGE NAME',
      'fir_no': 'FIR NUMBER',
      'fir_year': 'FIR YEAR',
      'fir_police_station': 'POLICE STATION',
      'priority': 'PRIORITY',
      'advocate_name': 'ADVOCATE NAME',
      'o_advocate': 'OPPOSITE ADVOCATE NAME',
      'summary': 'CASE SUMMARY UPLOAD',
      'ph': 'PHONE NO',
      'note_box': 'Description',
    };

    return fieldLabels.entries.map((entry) {
      final key = entry.key;
      final label = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _controllers[key],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                hintText: 'Enter $label',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ],
        ),
      );
    }).toList();
  }
}
