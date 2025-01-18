import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddReceiverPost extends StatefulWidget {
  const AddReceiverPost({super.key});

  @override
  _AddSenderPostState createState() => _AddSenderPostState();
}

class _AddSenderPostState extends State<AddReceiverPost> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _ilpClientController = TextEditingController();
  final TextEditingController _legalOppNameController = TextEditingController();
  final TextEditingController _docketNoController = TextEditingController();
  final TextEditingController _caseNoController = TextEditingController();
  final TextEditingController _advocateController = TextEditingController();
  String _status = 'Pending'; // Default status

  @override
  void dispose() {
    _dateController.dispose();
    _ilpClientController.dispose();
    _legalOppNameController.dispose();
    _docketNoController.dispose();
    _caseNoController.dispose();
    _advocateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://api.indataai.in/wereads/fetch_reciverpost.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'date': _dateController.text,
          'ilp_client': _ilpClientController.text,
          'legal_opp_name': _legalOppNameController.text,
          'docket_no': _docketNoController.text,
          'case_no': _caseNoController.text,
          'advocate': _advocateController.text,
          'status': _status,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sender post added successfully')),
        );
      } else {
        throw Exception('Failed to add sender post');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding post: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sender Post'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter date' : null,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _dateController.text =
                              date.toIso8601String().split('T')[0];
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ilpClientController,
                      decoration: const InputDecoration(
                        labelText: 'ILP Client',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter ILP client'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _legalOppNameController,
                      decoration: const InputDecoration(
                        labelText: 'Legal Opponent Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter legal opponent name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _docketNoController,
                      decoration: const InputDecoration(
                        labelText: 'Docket No',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter docket number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _caseNoController,
                      decoration: const InputDecoration(
                        labelText: 'Case No',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter case number'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _advocateController,
                      decoration: const InputDecoration(
                        labelText: 'Advocate',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter advocate name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Pending', 'In Progress', 'Completed']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _status = value!);
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
