import 'package:flutter/material.dart';
import 'customer_edit.dart'; // Import the EditCustomerPage file

class CustomerDetailPage extends StatelessWidget {
  final Map<String, dynamic> client;

  const CustomerDetailPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('${client['full_name']}\'s Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailBox('full name', client['full_name']),
            _buildDetailBox('number', client['number']),
            _buildDetailBox('email', client['email']),
            _buildDetailBox('address', client['address']),
            const SizedBox(height: 20),
            _buildActionButtons(context), // Edit button
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.blueAccent, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label: ${value ?? 'N/A'}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditCustomerPage(
                  client: client,
                  refreshParent:
                      () {}, // Provide an empty function if you don't need refresh functionality
                ),
              ),
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
