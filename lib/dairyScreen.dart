import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DairyScreen extends StatefulWidget {
  const DairyScreen({super.key});

  @override
  _DairyScreenState createState() => _DairyScreenState();
}

class _DairyScreenState extends State<DairyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController previousDateController = TextEditingController();
  final TextEditingController courtHallController = TextEditingController();
  final TextEditingController particularsController = TextEditingController();
  final TextEditingController stagesController = TextEditingController();
  final TextEditingController nextDateController = TextEditingController();
  bool _isLoading = false;

  // Submit the form data to the API
  Future<void> submitForm(String previousDate, String courtHall,
      String particulars, String stages, String nextDate) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://api.indataai.in/wereads/visitors1.php'), // Replace with the correct API URL
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'previous_date': previousDate,
          'court_hall': courtHall,
          'particulars': particulars,
          'stages': stages,
          'next_date': nextDate,
        },
      );

      setState(() {
        _isLoading = false; // Hide loading indicator after request
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _showPopupDialog(
          context,
          responseData['message'] != null ? 'Success' : 'Error',
          responseData['message'] ?? responseData['error'] ?? 'Unknown error',
        );
      } else {
        _showPopupDialog(
            context, 'Error', 'Failed to submit the form. Please try again.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
        title: const Text('Diary Form', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Previous Date'),
                _buildTextField(
                  controller: previousDateController,
                  hintText: 'Enter previous date',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 16),
                _buildLabel('Court Hall'),
                _buildTextField(
                  controller: courtHallController,
                  hintText: 'Enter court hall',
                  icon: Icons.business,
                ),
                const SizedBox(height: 16),
                _buildLabel('Particulars'),
                _buildTextField(
                  controller: particularsController,
                  hintText: 'Enter particulars',
                  icon: Icons.note,
                ),
                const SizedBox(height: 16),
                _buildLabel('Stage'),
                _buildTextField(
                  controller: stagesController,
                  hintText: 'Enter stage',
                  icon: Icons.flag,
                ),
                const SizedBox(height: 16),
                _buildLabel('Next Date'),
                _buildTextField(
                  controller: nextDateController,
                  hintText: 'Enter next date',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            submitForm(
                              previousDateController.text.trim(),
                              courtHallController.text.trim(),
                              particularsController.text.trim(),
                              stagesController.text.trim(),
                              nextDateController.text.trim(),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable function for text fields with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid value';
        }
        return null;
      },
    );
  }

  Widget _buildLabel(String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
