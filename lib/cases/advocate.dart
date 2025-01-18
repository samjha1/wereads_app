import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import this to parse JSON
import 'package:wereads/cases/advocate_add.dart';

class AdvocateListScreen extends StatefulWidget {
  const AdvocateListScreen({super.key});

  @override
  _AdvocateListScreenState createState() => _AdvocateListScreenState();
}

class _AdvocateListScreenState extends State<AdvocateListScreen> {
  late Future<List<dynamic>> _advocateList;

  @override
  void initState() {
    super.initState();
    _advocateList = fetchAdvocates();
  }

  Future<List<dynamic>> fetchAdvocates() async {
    // Replace the hardcoded URL with the actual API endpoint
    final response = await http
        .get(Uri.parse('https://api.indataai.in/wereads/advocate_list.php'));

    if (response.statusCode == 200) {
      // If the server returns a 200 response, parse the JSON data
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // If the server does not return a 200 response, throw an error
      throw Exception('Failed to load advocates');
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
          'Advocate List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor:
            Theme.of(context).primaryColor, // Customize as per your theme
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _advocateList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final advocate = data[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  elevation: 5.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    leading: const Icon(Icons.gavel, color: Colors.purple),
                    title: Text(
                      advocate['ad_name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${advocate['ad_phone']}'),
                        Text('Email: ${advocate['ad_mail']}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditAdvocateDetailsScreen(advocate: advocate),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewadvocatePage()),
          );
        },
        tooltip: 'Add New Advocate',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EditAdvocateDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> advocate;

  const EditAdvocateDetailsScreen({super.key, required this.advocate});

  @override
  _EditAdvocateDetailsScreenState createState() =>
      _EditAdvocateDetailsScreenState();
}

class _EditAdvocateDetailsScreenState extends State<EditAdvocateDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController line1Controller;
  late TextEditingController line2Controller;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController zipController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the existing advocate details
    nameController = TextEditingController(text: widget.advocate['ad_name']);
    phoneController = TextEditingController(text: widget.advocate['ad_phone']);
    emailController = TextEditingController(text: widget.advocate['ad_mail']);
    addressController =
        TextEditingController(text: widget.advocate['ad_address']);
    line1Controller = TextEditingController(text: widget.advocate['ad_line1']);
    line2Controller = TextEditingController(text: widget.advocate['ad_line2']);
    countryController = TextEditingController(text: widget.advocate['country']);
    stateController = TextEditingController(text: widget.advocate['state']);
    cityController = TextEditingController(text: widget.advocate['city']);
    zipController = TextEditingController(text: widget.advocate['zip']);
  }

  @override
  void dispose() {
    // Dispose of text controllers when the screen is disposed
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  // Update advocate details function
  Future<void> _updateAdvocateDetails() async {
    const url =
        'https://api.indataai.in/wereads/advocate_edit.php'; // Replace with your PHP URL

    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': widget.advocate['id'].toString(),
        'ad_name': nameController.text,
        'ad_phone': phoneController.text,
        'ad_mail': emailController.text,
        'ad_address': addressController.text,
        'ad_line1': line1Controller.text,
        'ad_line2': line2Controller.text,
        'country': countryController.text,
        'state': stateController.text,
        'city': cityController.text,
        'zip': zipController.text,
      },
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 &&
        responseData['message'] == 'Advocate details updated successfully.') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Advocate details updated successfully!'),
      ));
      Navigator.pop(context); // Go back to the previous screen after saving
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update advocate details.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Advocate Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Name', nameController),
            _buildTextField('Phone', phoneController),
            _buildTextField('Email', emailController),
            _buildTextField('Address', addressController),
            _buildTextField('Address Line 1', line1Controller),
            _buildTextField('Address Line 2', line2Controller),
            _buildTextField('Country', countryController),
            _buildTextField('State', stateController),
            _buildTextField('City', cityController),
            _buildTextField('ZIP/Postal Code', zipController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call the update function and wait for the result
                await _updateAdvocateDetails();

                // After updating, navigate to a new page (for example, a confirmation or next screen)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AdvocateListScreen(), // Replace NewPage with your desired page
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to create text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
