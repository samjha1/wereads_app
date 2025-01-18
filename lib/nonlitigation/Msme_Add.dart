import 'package:flutter/material.dart';

class MsmeAdd extends StatefulWidget {
  const MsmeAdd({super.key});

  @override
  _CorporateFormState createState() => _CorporateFormState();
}

class _CorporateFormState extends State<MsmeAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedClient;
  TextEditingController partyNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController advocateNameController = TextEditingController();
  TextEditingController oppositeAdvocateController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController contractTitleController = TextEditingController();
  TextEditingController regularityController = TextEditingController();
  TextEditingController documentsUploadController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  String? contractType;
  String? approvalStatus;
  DateTime? commiDate, compDate, actionDate, fillingDeadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MSME AND BUSINESS FORM"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Client Name*",
                  border: OutlineInputBorder(),
                ),
                value: selectedClient,
                items: ["Client A", "Client B", "Client C"]
                    .map((client) => DropdownMenuItem(
                          value: client,
                          child: Text(client),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClient = value;
                    // Simulate fetching client data
                    if (value == "Client A") {
                      partyNameController.text = "Party A";
                      titleController.text = "Title A";
                    }
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a client" : null,
              ),
              const SizedBox(height: 16.0),
              buildTextField("Your Party Name", partyNameController),
              buildTextField("Title", titleController),
              buildDatePicker("Date of Commencement", commiDate, (date) {
                setState(() => commiDate = date);
              }),
              buildDatePicker("Date of Completion", compDate, (date) {
                setState(() => compDate = date);
              }),
              buildTextField("Priority", priorityController),
              buildTextField("Advocate Name", advocateNameController),
              buildTextField(
                  "Opposite Advocate Name", oppositeAdvocateController),
              buildFileField("Case Summary Upload"),
              buildTextField(
                "Mobile No",
                phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a mobile number";
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return "Enter a valid 10-digit number";
                  }
                  return null;
                },
              ),
              buildDatePicker("Action Date", actionDate, (date) {
                setState(() => actionDate = date);
              }),
              buildTextField("Remarks", remarksController),
              const SizedBox(height: 8.0),
              buildTextField("Contract Title", contractTitleController),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Contract Type",
                  border: OutlineInputBorder(),
                ),
                value: contractType,
                items: [
                  "Vendor Agreement",
                  "Employment Contract",
                  "NDAs",
                  "Partnership Agreements",
                  "Others"
                ]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => contractType = value),
              ),
              const SizedBox(height: 8.0),
              buildDatePicker("Filling Deadline", fillingDeadline, (date) {
                setState(() => fillingDeadline = date);
              }),
              const SizedBox(height: 8.0),
              buildTextField("Regularity Filling", regularityController),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Approval Status",
                  border: OutlineInputBorder(),
                ),
                value: approvalStatus,
                items: ["Approved", "Pending", "Overdue"]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => approvalStatus = value),
              ),
              const SizedBox(height: 8.0),
              buildTextField("remark", remarkController),
              const SizedBox(height: 8.0),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Data successfully saved")),
                        );
                      }
                    },
                    child: const Text("Save"),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget buildDatePicker(
      String label, DateTime? selectedDate, ValueChanged<DateTime?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          onChanged(pickedDate);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            selectedDate != null
                ? "${selectedDate.toLocal()}".split(' ')[0]
                : "Select Date",
          ),
        ),
      ),
    );
  }

  Widget buildFileField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: () {
              // Implement file picker logic
            },
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload File"),
          ),
        ],
      ),
    );
  }
}
