import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCustomerPage extends StatefulWidget {
  final Map<String, dynamic> client;
  final Function refreshParent; // Callback to refresh the parent

  const EditCustomerPage(
      {super.key, required this.client, required this.refreshParent});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  late TextEditingController fullNameController;
  late TextEditingController numberController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  bool isLoading = false;

  // Use the correct API URL for updating customer details
  final String apiUrl = 'https://api.indataai.in/wereads/update_customer.php';

  @override
  void initState() {
    super.initState();
    fullNameController =
        TextEditingController(text: widget.client['full_name']);
    numberController = TextEditingController(text: widget.client['number']);
    emailController = TextEditingController(text: widget.client['email']);
    addressController = TextEditingController(text: widget.client['address']);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    numberController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    if (fullNameController.text.isEmpty ||
        numberController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('All fields are required'),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': widget.client['id'].toString(),
          'full_name': fullNameController.text,
          'number': numberController.text,
          'email': emailController.text,
          'address': addressController.text,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Customer updated successfully'),
          ));
          Navigator.pop(context); // Close the edit page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Failed to update customer: ${result['error'] ?? 'Unknown error'}'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Server error: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Network error: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Full Name', fullNameController),
                  _buildTextField('Number', numberController,
                      keyboardType: TextInputType.phone),
                  _buildTextField('Email', emailController,
                      keyboardType: TextInputType.emailAddress),
                  _buildTextField('Address', addressController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateCustomer,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
