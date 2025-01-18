// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'front_page.dart';
import 'profile.dart';
import 'settings.dart';

class SiteBookingPage extends StatefulWidget {
  const SiteBookingPage({super.key});

  @override
  SiteBookingPageState createState() => SiteBookingPageState();
}

class SiteBookingPageState extends State<SiteBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _applicationIdController =
      TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  String? _selectedName;
  List<String> _names = [];

  @override
  void initState() {
    super.initState();
    _fetchNames(); // Fetch names when the screen loads
  }

  Future<void> _fetchNames() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.indataai.in/durga/get_all_visitors.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _names = data.map((name) => name['full_name'] as String).toList();
        });
      } else {
        // Error handling for non-200 response
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load names')),
        );
      }
    } catch (e) {
      // Handle any exceptions during the HTTP request
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching names')),
      );
    }
  }

  Future<void> _fetchDetails(String name) async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2/api/wereads/fetch_details.php?name=$name'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _applicationIdController.text =
              data['id'].toString(); // Convert to string if necessary
          _relationController.text =
              data['number'].toString(); // Ensure it's a string
          _dobController.text = data['dob'] ?? ''; // Check for null
          _occupationController.text =
              data['occupation'] ?? ''; // Check for null
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load details')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching details')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> data = {
        'application_id': _applicationIdController.text,
        'full_name': _selectedName ?? '',
        'relation': _relationController.text,
        'dob': _dobController.text,
        'occupation': _occupationController.text,
      };

      try {
        var response = await http.post(
          Uri.parse('https://api.indataai.in/durga/site_booking.php'),
          body: data,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Form submitted successfully: ${response.body}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to submit form: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting form')),
        );
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Site Booking Form'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Fill in the details below:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedName,
                  hint: const Text('Select Name',
                      style: TextStyle(color: Colors.grey)),
                  items: _names.map((String name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedName = newValue;
                      if (newValue != null) {
                        _fetchDetails(newValue); // Fetch details on selection
                      }
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(_applicationIdController, 'Application ID'),
                const SizedBox(height: 20),
                _buildTextField(_relationController, 'Relation'),
                const SizedBox(height: 20),
                _buildTextField(_dobController, 'Date of Birth (YYYY-MM-DD)'),
                const SizedBox(height: 20),
                _buildTextField(_occupationController, 'Occupation'),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70.0,
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminDashboard()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
