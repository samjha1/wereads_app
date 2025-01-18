// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewadvocatePage extends StatefulWidget {
  const NewadvocatePage({super.key});

  @override
  _NewCasePageState createState() => _NewCasePageState();
}

class _NewCasePageState extends State<NewadvocatePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = {};

  // TextEditingControllers for each field
  final Map<String, TextEditingController> _controllers = {};

  // Initialize the controllers with empty values
  @override
  void initState() {
    super.initState();
    _controllers.addAll({
      'Name': TextEditingController(),
      'Phone': TextEditingController(),
      'Email': TextEditingController(),
      'Address': TextEditingController(),
      'Address_Line_1': TextEditingController(),
      'Address_Line_2': TextEditingController(),
      'country': TextEditingController(),
      'state': TextEditingController(),
      'city': TextEditingController(),
      'ZIP/Postal Code': TextEditingController(),
    });
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ensure that all required fields are included in formData
      bool allRequiredFieldsFilled = true;
      formData.forEach((key, value) {
        if (value.isEmpty) {
          allRequiredFieldsFilled = false;
        }
      });

      if (!allRequiredFieldsFilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return;
      }

      var url = Uri.parse('https://api.indataai.in/wereads/advocate_add.php');
      var response = await http.post(url, body: formData);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Case saved successfully'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message'] ?? 'Failed to save case'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error connecting to the server'),
        ));
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Add New advocate',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Name', 'ad_name'),
              _buildTextField('Phone', 'ad_phone'),
              _buildTextField('Email', 'ad_mail'),
              _buildTextField('Address', 'ad_address'),
              _buildTextField('Address_Line_1', 'ad_line1'),
              _buildTextField('Address_Line_2', 'ad_line2'),
              _buildTextField('country', 'country'),
              _buildTextField('State', 'state'),
              _buildTextField('City', 'city'),
              _buildTextField('ZIP/Postal Code', 'zip'),
              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key) {
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
            controller:
                _controllers[key], // Assigning the respective controller
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              hintText: 'Enter $label',
            ),
            onSaved: (value) {
              if (value != null) {
                formData[key] = value;
              }
            },
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
  }
}
