import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Company Client",
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
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController EMAILController = TextEditingController();
  final TextEditingController MOBILEController = TextEditingController();
  final TextEditingController SOCIALController = TextEditingController();
  final TextEditingController PANController = TextEditingController();
  final TextEditingController TANController = TextEditingController();
  final TextEditingController WEBSITEController = TextEditingController();
  final TextEditingController SUBCATEGORYController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController category1Controller = TextEditingController();
  final TextEditingController sub_categoryController = TextEditingController();
  final TextEditingController campany_typeController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController externalController = TextEditingController();

  Future<void> submitForm() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.indataai.in/wereads/company.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'company_name': clientNameController.text.trim(),
          'contact_type1': CONTACTTYPEController.text.trim(),
          'address1': ADDRESSController.text.trim(),
          'state1': STATEController.text.trim(),
          'city1': cityController.text.trim(),
          'zcode1': zipCodeController.text.trim(),
          'mail1': EMAILController.text.trim(),
          'ph1': MOBILEController.text.trim(),
          'social1': SOCIALController.text.trim(),
          'pan1': PANController.text.trim(),
          'tan1': TANController.text.trim(),
          'cin': WEBSITEController.text.trim(),
          'isin': SUBCATEGORYController.text.trim(),
          'website1': WEBSITEController.text.trim(),
          'source': sourceController.text.trim(),
          'sector': sectorController.text.trim(),
          'category1': category1Controller.text.trim(),
          'sub_category': sub_categoryController.text.trim(),
          'company_type': campany_typeController.text.trim(),
          'group1': groupController.text.trim(),
          'external': externalController.text.trim(),
          'roleSelector': 'company',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          _showPopupDialog(context, 'Success', 'Company added successfully');
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField('Client Name', clientNameController, Icons.person,
              'Enter client name'),
          buildField('CONTACT TYPE', CONTACTTYPEController, Icons.phone,
              'Enter CONTACT TYPE'),
          buildField(
              'ADDRESS', ADDRESSController, Icons.email, 'Enter ADDRESS'),
          buildField(
              'STATE', STATEController, Icons.location_on, 'Enter STATE'),
          buildField('CITY', cityController, Icons.location_city, 'Enter city'),
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
          buildField('WEBSITE', WEBSITEController, Icons.web, 'Enter WEBSITE'),
          buildField('SUB CATEGORY', SUBCATEGORYController, Icons.category,
              'Enter SUB CATEGORY'),
          buildField('SOURCE', sourceController, Icons.source,
              'Enter Source Information'),
          buildField(
              'SECTOR', sectorController, Icons.business, 'Enter SECTOR'),
          buildField('CATEGORY', category1Controller, Icons.category,
              'Enter Category'),
          buildField('SUB CATEGORY', sub_categoryController, Icons.category,
              'Enter Sub Category'),
          buildField('COMPANY TYPE', campany_typeController, Icons.business,
              'Enter Company Type'),
          buildField('GROUP', groupController, Icons.group, 'Enter Group'),
          buildField('EXTERNAL', externalController, Icons.eco,
              'Enter External Reference'),
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
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  bool allFieldsFilled() {
    return clientNameController.text.isNotEmpty &&
        CONTACTTYPEController.text.isNotEmpty &&
        ADDRESSController.text.isNotEmpty &&
        STATEController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        zipCodeController.text.isNotEmpty &&
        EMAILController.text.isNotEmpty &&
        MOBILEController.text.isNotEmpty &&
        SOCIALController.text.isNotEmpty &&
        PANController.text.isNotEmpty &&
        TANController.text.isNotEmpty &&
        WEBSITEController.text.isNotEmpty &&
        SUBCATEGORYController.text.isNotEmpty &&
        sourceController.text.isNotEmpty &&
        sectorController.text.isNotEmpty &&
        category1Controller.text.isNotEmpty &&
        sub_categoryController.text.isNotEmpty &&
        campany_typeController.text.isNotEmpty &&
        groupController.text.isNotEmpty &&
        externalController.text.isNotEmpty;
  }

  Widget buildField(String label, TextEditingController controller,
      IconData icon, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
