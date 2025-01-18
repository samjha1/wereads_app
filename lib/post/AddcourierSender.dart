import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddcourierSender extends StatefulWidget {
  const AddcourierSender({super.key});

  @override
  AddRegisterPostSenderState createState() => AddRegisterPostSenderState();
}

class AddRegisterPostSenderState extends State<AddcourierSender> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _actionDateController = TextEditingController();
  final _ilpClientController = TextEditingController();
  final _legalOppController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _natureController = TextEditingController();
  final _docketController = TextEditingController();
  final _caseNumController = TextEditingController();
  final _sectionController = TextEditingController();
  final _remarksController = TextEditingController();

  String? _selectedAdvocate;
  String? _selectedStatus;
  List<String> _advocateList = [];
  final List<String> _statusList = ['Pending', 'Completed', 'Process'];

  @override
  void initState() {
    super.initState();
    _fetchAdvocates();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Fetch advocate names from API
  Future<void> _fetchAdvocates() async {
    final response = await http
        .get(Uri.parse('https://api.indataai.in/wereads/advocatenames.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _advocateList = data.map((item) => item['ad_name'] as String).toList();
      });
    } else {
      throw Exception('Failed to load advocates');
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _actionDateController.dispose();
    _ilpClientController.dispose();
    _legalOppController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _natureController.dispose();
    _docketController.dispose();
    _caseNumController.dispose();
    _sectionController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare form data
      final formData = {
        "dt": _dateController.text,
        "s_ilpclient": _ilpClientController.text,
        "s_legalopp": _legalOppController.text,
        "s_address": _addressController.text,
        "s_email": _emailController.text,
        "s_phone": _phoneController.text,
        "s_nature": _natureController.text,
        "s_docket": _docketController.text,
        "s_casenum": _caseNumController.text,
        "s_section": _sectionController.text,
        "s_attorny": _selectedAdvocate,
        "status": _selectedStatus,
        "s_next_date": _actionDateController.text,
        "s_remarks": _remarksController.text,
        "roleSelector": "sender", // Hidden value included
      };

      // API endpoint
      const String apiUrl =
          "https://api.indataai.in/wereads/addcouriersender.php?action=save_registerpost";

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: formData,
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          if (responseBody == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted successfully!')),
            );
            Navigator.pop(context); // Return to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseBody.toString()}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to submit form. Status: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildFormField({
    required String label,
    Widget? child,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: child ??
                TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: validator,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Add Courier Post Sender',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildFormField(
                  label: 'Date',
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _dateController),
                ),
                _buildFormField(
                  label: 'ILP Client Name',
                  controller: _ilpClientController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ILP client name';
                    }
                    return null;
                  },
                ),
                _buildFormField(
                    label: 'Legal-Opp Name', controller: _legalOppController),
                _buildFormField(
                    label: 'Address', controller: _addressController),
                _buildFormField(label: 'Email', controller: _emailController),
                _buildFormField(
                  label: 'Contact Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                _buildFormField(label: 'Nature', controller: _natureController),
                _buildFormField(
                    label: 'Docket Reference', controller: _docketController),
                _buildFormField(
                    label: 'Case Number', controller: _caseNumController),
                _buildFormField(
                    label: 'Section', controller: _sectionController),
                _buildFormField(
                  label: 'ILP Advocate',
                  child: DropdownButtonFormField<String>(
                    value: _selectedAdvocate,
                    items: _advocateList
                        .map((advocate) => DropdownMenuItem(
                              value: advocate,
                              child: Text(advocate),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAdvocate = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _buildFormField(
                  label: 'Status',
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: _statusList
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _buildFormField(
                  label: 'Action Date',
                  controller: _actionDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _actionDateController),
                ),
                _buildFormField(
                    label: 'Remarks', controller: _remarksController),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
