import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditPostScreen1 extends StatefulWidget {
  final Map<String, dynamic> post;
  final String type;

  const EditPostScreen1({super.key, required this.post, required this.type});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen1> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dtController;
  late TextEditingController _sIlpClientController;
  late TextEditingController _sLegalOppController;
  late TextEditingController _sAddressController;
  late TextEditingController _sEmailController;
  late TextEditingController _sPhoneController;
  late TextEditingController _sNatureController;
  late TextEditingController _sCaseNumController;
  late TextEditingController _sSectionController;
  late TextEditingController _sAttorneyController;
  late TextEditingController _sNextDateController;
  late TextEditingController _sRemarksController;
  String _selectedStatus = '';
  final String _roleSelector = 'receiver'; // Fixed role for now

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing post values
    _dtController = TextEditingController(text: widget.post['dt1']);
    _sIlpClientController =
        TextEditingController(text: widget.post['r_ilpclient']);
    _sLegalOppController =
        TextEditingController(text: widget.post['r_legalopp']);
    _sAddressController = TextEditingController(text: widget.post['r_adress']);
    _sEmailController = TextEditingController(text: widget.post['r_mail']);
    _sPhoneController = TextEditingController(text: widget.post['r_phone']);
    _sNatureController = TextEditingController(text: widget.post['r_nature']);
    _sCaseNumController = TextEditingController(text: widget.post['r_casenum']);
    _sSectionController = TextEditingController(text: widget.post['r_section']);
    _sAttorneyController =
        TextEditingController(text: widget.post['r_attorny']);
    _sNextDateController =
        TextEditingController(text: widget.post['r_next_date']);
    _sRemarksController = TextEditingController(text: widget.post['r_remarks']);
    _selectedStatus = widget.post['status'] ?? '';
  }

  // Function to submit the form data to the backend
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Prepare the data to send to the backend
      final response = await http.post(
        Uri.parse(
            'https://api.indataai.in/wereads/addcourierreciver.php?action=save_registerpost'),
        body: {
          'id': widget.post['id'].toString(),
          'dt1': _dtController.text,
          'r_ilpclient': _sIlpClientController.text,
          'r_legalopp': _sLegalOppController.text,
          'r_adress': _sAddressController.text,
          'r_mail': _sEmailController.text,
          'r_phone': _sPhoneController.text,
          'r_nature': _sNatureController.text,
          'r_casenum': _sCaseNumController.text,
          'r_section': _sSectionController.text,
          'r_attorny': _sAttorneyController.text,
          'status': _selectedStatus,
          'r_next_date': _sNextDateController.text,
          'r_remarks': _sRemarksController.text,
          'roleSelector': _roleSelector,
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        // Handle success (e.g., navigate back or show a success message)
        Navigator.pop(context);
      } else {
        // Handle failure (e.g., show an error message)
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(responseBody['error'] ?? 'Failed to save data'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Post reciver'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_dtController, 'Date'),
              _buildTextField(_sIlpClientController, 'ILP Client'),
              _buildTextField(_sLegalOppController, 'Legal Opponent'),
              _buildTextField(_sAddressController, 'Address'),
              _buildTextField(_sEmailController, 'Email'),
              _buildTextField(_sPhoneController, 'Phone'),
              _buildTextField(_sNatureController, 'Nature'),
              _buildTextField(_sCaseNumController, 'Case Number'),
              _buildTextField(_sSectionController, 'Section'),
              _buildTextField(_sAttorneyController, 'Attorney'),
              _buildTextField(_sNextDateController, 'Next Date'),
              _buildTextField(_sRemarksController, 'Remarks'),
              DropdownButton<String>(
                value: _selectedStatus,
                hint: const Text('Select Status'),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value ?? '';
                  });
                },
                items: ['Pending', 'Completed', 'Process']
                    .map<DropdownMenuItem<String>>((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with labels above them
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: 14, color: Colors.grey), // Smaller label size
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 12.0), // Reduced height
            border: InputBorder.none,
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter $label' : null,
        ),
      ),
    );
  }
}
