import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add OTHERS CLIENT",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController CONTACTTYPEController = TextEditingController();
  final TextEditingController ADDRESSController = TextEditingController();
  final TextEditingController STATEController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController EMAILController = TextEditingController();
  final TextEditingController MOBILEController = TextEditingController();
  final TextEditingController SOCIALController = TextEditingController();
  final TextEditingController PANController = TextEditingController();
  final TextEditingController TANController = TextEditingController();
  final TextEditingController WEBSITEController = TextEditingController();
  final TextEditingController SUBCATEGORYController = TextEditingController();

  Future<void> submitForm() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.indataai.in/wereads/customers.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_name': clientNameController.text.trim(),
          'contact_type': CONTACTTYPEController.text.trim(),
          'address': ADDRESSController.text.trim(),
          'state': STATEController.text.trim(),
          'city': cityController.text.trim(),
          'zcode': zipCodeController.text.trim(),
          'mail': EMAILController.text.trim(),
          'ph': MOBILEController.text.trim(),
          'social': SOCIALController.text.trim(),
          'pan': PANController.text.trim(),
          'tan': TANController.text.trim(),
          'website': WEBSITEController.text.trim(),
          'category': SUBCATEGORYController.text.trim(),
          'roleSelector': 'client',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['message'] != null) {
          _showPopupDialog(context, 'Success', responseData['message']);
        } else {
          _showPopupDialog(context, 'Error',
              responseData['error'] ?? 'Something went wrong!');
        }
      } else {
        _showPopupDialog(
            context, 'Error', 'Failed to submit form. Please try again.');
      }
    } catch (e) {
      _showPopupDialog(context, 'Error', 'An error occurred: $e');
    }
  }

  void _showPopupDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildField('Client Name', clientNameController, Icons.person,
                'Enter client name'),
            buildField('CONTACT TYPE', CONTACTTYPEController, Icons.phone,
                'Enter phone number'),
            buildField(
                'ADDRESS', ADDRESSController, Icons.email, 'Enter ADDRESS'),
            buildField(
                'STATE', STATEController, Icons.location_on, 'Enter STATE'),
            buildField(
                'CITY', cityController, Icons.location_city, 'Enter city'),
            buildField('ZIP/POST CODE', zipCodeController, Icons.map,
                'Enter ZIP/POST CODE'),
            buildField('EMAIL ID', EMAILController, Icons.local_post_office,
                'Enter EMAIL'),
            buildField('MOBILE NO', MOBILEController, Icons.phone_enabled,
                'Enter MOBILE'),
            buildField('SOCIAL', SOCIALController, Icons.social_distance,
                'Enter SOCIAL'),
            buildField('PAN', PANController, Icons.pan_tool, 'Enter PAN'),
            buildField('TAN', TANController, Icons.abc, 'Enter TAN'),
            buildField(
                'WEBSITE', WEBSITEController, Icons.web, 'Enter WEBSITE'),
            buildField('SUB CATEGORY', SUBCATEGORYController, Icons.category,
                'Enter SUB CATEGORY'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  if (allFieldsFilled()) {
                    submitForm();
                  } else {
                    _showPopupDialog(
                        context, 'Error', 'Please fill in all fields.');
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool allFieldsFilled() {
    return clientNameController.text.trim().isNotEmpty &&
        CONTACTTYPEController.text.trim().isNotEmpty &&
        ADDRESSController.text.trim().isNotEmpty &&
        STATEController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        zipCodeController.text.trim().isNotEmpty &&
        EMAILController.text.trim().isNotEmpty &&
        MOBILEController.text.trim().isNotEmpty &&
        SOCIALController.text.trim().isNotEmpty &&
        PANController.text.trim().isNotEmpty &&
        TANController.text.trim().isNotEmpty &&
        WEBSITEController.text.trim().isNotEmpty &&
        SUBCATEGORYController.text.trim().isNotEmpty;
  }
}
