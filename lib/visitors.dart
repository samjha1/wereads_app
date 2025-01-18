import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Visitors());
}

class Visitors extends StatefulWidget {
  const Visitors({super.key});

  @override
  _VisitorsState createState() => _VisitorsState();
}

class _VisitorsState extends State<Visitors> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController advocateController = TextEditingController();

  Future<void> submitForm(String fullName, String number, String address,
      String email, String purpose, String advocate) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.indataai.in/wereads/visitors1.php'), // Use 10.0.2.2 for emulator
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fname': fullName,
          'phone': number,
          'address': address,
          'mail': email,
          'purpose': purpose,
          'advocate': advocate,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] != null) {
          // Show success Snackbar
          _showSnackbar(context, 'Success: ${responseData['message']}');
          Navigator.pop(context); // Go back to the previous page
        } else {
          _showSnackbar(context,
              'Error: ${responseData['error'] ?? 'Something went wrong!'}');
        }
      } else {
        _showSnackbar(context,
            'Error: Failed to submit form. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar(context, 'Error: An unexpected error occurred: $e');
    }
  }

  // Method to show Snackbar
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Duration for the Snackbar
        backgroundColor:
            message.startsWith('Error') ? Colors.red : Colors.green,
      ),
    );
  }

  // Method to build reusable text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Enquiry Form', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: fullNameController,
              label: 'Full Name',
              icon: Icons.person,
              hint: 'Enter your full name',
            ),
            _buildTextField(
              controller: numberController,
              label: 'Phone Number',
              icon: Icons.phone,
              hint: 'Enter your phone number',
            ),
            _buildTextField(
              controller: addressController,
              label: 'Address',
              icon: Icons.home,
              hint: 'Enter your address',
            ),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              hint: 'Enter your email',
            ),
            _buildTextField(
              controller: purposeController,
              label: 'Purpose',
              icon: Icons.info_outline,
              hint: 'Enter the purpose',
            ),
            _buildTextField(
              controller: advocateController,
              label: 'Advocate',
              icon: Icons.person_outline,
              hint: 'Enter advocate name',
            ),
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
                onPressed: () async {
                  String fullName = fullNameController.text.trim();
                  String phone = numberController.text.trim();
                  String email = emailController.text.trim();
                  String address = addressController.text.trim();
                  String purpose = purposeController.text.trim();
                  String advocate = advocateController.text.trim();

                  if (fullName.isNotEmpty &&
                      phone.isNotEmpty &&
                      email.isNotEmpty &&
                      address.isNotEmpty &&
                      purpose.isNotEmpty &&
                      advocate.isNotEmpty) {
                    await submitForm(
                        fullName, phone, address, email, purpose, advocate);
                  } else {
                    _showSnackbar(context, 'Error: Please fill in all fields.');
                  }
                },
                child: const Text('Submit',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
