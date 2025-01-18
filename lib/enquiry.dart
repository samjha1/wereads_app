import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class enquiryScreen extends StatefulWidget {
  const enquiryScreen({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<enquiryScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController meetingPersonController = TextEditingController();

  Future<void> submitForm(String fullName, String number, String purpose,
      String meetingPerson) async {
    final response = await http.post(
      Uri.parse(
          'http://api.indataai.in/wereads/visitors.php'), // Update this URL
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'full_name': fullName,
        'number': number,
        'purpose': purpose,
        'meeting_person': meetingPerson,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message'] != null) {
        // Show the popup dialog on successful insertion
        _showPopupDialog(context, 'Success', responseData['message']);
      } else {
        // Handle error case
        _showPopupDialog(
            context, 'Error', responseData['error'] ?? 'Something went wrong!');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      _showPopupDialog(
          context, 'Error', 'Failed to submit form. Please try again.');
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
                Navigator.of(context).pop(); // Close the popup
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Enquiry Form',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Full Name
            const Text('Full Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                hintText: 'Enter your full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Number
            const Text('Phone Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Purpose
            const Text('Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: purposeController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                hintText: 'Enter Email id',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Meeting Person
            const Text('Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: meetingPersonController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                hintText: 'Enter full Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button (Centered)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  String fullName = fullNameController.text.trim();
                  String number = numberController.text.trim();
                  String purpose = purposeController.text.trim();
                  String meetingPerson = meetingPersonController.text.trim();

                  if (fullName.isNotEmpty &&
                      number.isNotEmpty &&
                      purpose.isNotEmpty &&
                      meetingPerson.isNotEmpty) {
                    submitForm(fullName, number, purpose, meetingPerson);
                  } else {
                    _showPopupDialog(
                        context, 'Error', 'Please fill in all fields.');
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
