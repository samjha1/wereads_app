import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewactivityPage extends StatefulWidget {
  const NewactivityPage({super.key});

  @override
  _NewCasePageState createState() => _NewCasePageState();
}

class _NewCasePageState extends State<NewactivityPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = {};

  // TextEditingControllers for each field
  final Map<String, TextEditingController> _controllers = {};

  // Initialize the controllers with empty values
  @override
  void initState() {
    super.initState();
    _controllers.addAll({
      'DATE': TextEditingController(),
      'CLIENT:MATTER': TextEditingController(),
      'WORKED': TextEditingController(),
      'BILLABLE': TextEditingController(),
      'CATEGORY/NOTES': TextEditingController(),
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

      var url = Uri.parse('https://api.indataai.in/wereads/litigation_add.php');
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

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        // Format the date to "YYYY-MM-DD"
        String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];
        _controllers['DATE']?.text = formattedDate;
        formData['DATE'] = formattedDate; // Save the date in formData
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'ADD DAILY ACTIVITY',
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
              _buildTextField('DATE', 'DATE', isDateField: true),
              _buildTextField('CLIENT:MATTER', 'CLIENT:MATTER'),
              _buildTextField('WORKED', 'WORKED'),
              _buildTextField('BILLABLE', 'BILLABLE'),
              _buildTextField('CATEGORY/NOTES', 'CATEGORY/NOTES'),
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

  Widget _buildTextField(String label, String key, {bool isDateField = false}) {
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
            onTap: isDateField
                ? () => _selectDate(context)
                : null, // Open the date picker if this is the DATE field
            readOnly: isDateField, // Disable typing in the DATE field
          ),
        ],
      ),
    );
  }
}
