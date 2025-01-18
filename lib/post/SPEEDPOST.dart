import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wereads/post/AddspeedReceiver.dart';
import 'package:wereads/post/AddspeedSender.dart';
import 'package:wereads/post/editspeed.dart';

class SPEEDPOSTList extends StatefulWidget {
  const SPEEDPOSTList({super.key});

  @override
  _RegisterPostListState createState() => _RegisterPostListState();
}

class _RegisterPostListState extends State<SPEEDPOSTList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  String errorMessage = '';
  List<Map<String, dynamic>> senderData = [];
  List<Map<String, dynamic>> receiverData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch sender data
      final senderResponse = await http.get(
        Uri.parse('https://api.indataai.in/wereads/speedsender.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (senderResponse.statusCode == 200) {
        final dynamic senderList = json.decode(senderResponse.body);

        // Check if the response is a List
        if (senderList is List) {
          senderData =
              senderList.map((item) => item as Map<String, dynamic>).toList();
        } else {
          throw Exception('Expected a list but got: ${senderList.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load sender data: ${senderResponse.statusCode}');
      }

      // Fetch receiver data
      final receiverResponse = await http.get(
        Uri.parse('https://api.indataai.in/wereads/speedreciver.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (receiverResponse.statusCode == 200) {
        final dynamic receiverList = json.decode(receiverResponse.body);

        // Check if the response is a List
        if (receiverList is List) {
          receiverData =
              receiverList.map((item) => item as Map<String, dynamic>).toList();
        } else {
          throw Exception(
              'Expected a list but got: ${receiverList.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load receiver data: ${receiverResponse.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePost(String id, String type) async {
    try {
      final response = await http.delete(
        Uri.parse('https://api.indataai.in/wereads/delete_post.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'type': type}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully')),
        );
        setState(() {
          // Remove the deleted post from the data list
          if (type == 'sender') {
            senderData.removeWhere((item) => item['id'] == id);
          } else {
            receiverData.removeWhere((item) => item['id'] == id);
          }
        });
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
  }

  Widget _buildPostCard(Map<String, dynamic> post, String type) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${post['dt']}'),
            Text('Client: ${post['s_ilpclient']}'),
            Text('Case No: ${post['s_legalopp']}'),
            Text('Status: ${post['status']}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        if (type == 'sender') {
                          return PostDetailScreen(
                            post: post,
                          );
                        } else {
                          return PostDetailScreen1(
                            post: post,
                          );
                        }
                      }),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          if (type == 'sender') {
                            return EditPostScreen(post: post, type: type);
                          } else {
                            return EditPostScreen1(post: post, type: type);
                          }
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(post['id'], type),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deletePost(id, type);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Speed Post Posts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sender'),
            Tab(text: 'Receiver'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: senderData.length,
                      itemBuilder: (context, index) {
                        return _buildPostCard(senderData[index], 'sender');
                      },
                    ),
                    ListView.builder(
                      itemCount: receiverData.length,
                      itemBuilder: (context, index) {
                        return _buildPostCard(receiverData[index], 'receiver');
                      },
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _tabController.index == 0
                  ? const AddspeedSender()
                  : const AddspeedReceiver(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Post Details', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Date: ${post['dt']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Client: ${post['s_ilpclient']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Case No: ${post['s_legalopp']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('PHONE NUMBER: ${post['s_phone']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Status: ${post['status']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Docket No: ${post['s_docket']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  'Case No: ${post['s_casenum']}'), // Replace with the actual field you want
            ),
          ],
        ),
      ),
    );
  }
}

class EditPostScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String type;

  const EditPostScreen({super.key, required this.post, required this.type});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dtController;
  late TextEditingController _sIlpClientController;
  late TextEditingController _sLegalOppController;
  late TextEditingController _sAddressController;
  late TextEditingController _sEmailController;
  late TextEditingController _sPhoneController;
  late TextEditingController _sNatureController;
  late TextEditingController _sDocketController;
  late TextEditingController _sCaseNumController;
  late TextEditingController _sSectionController;
  String?
      _selectedAdvocate; // _selectedAdvocate is a String, not a TextEditingController
  late TextEditingController _sNextDateController;
  late TextEditingController _sRemarksController;
  String _selectedStatus = '';
  List<String> _advocateList = [];
  final String _roleSelector = 'sender'; // Fixed role for now

  @override
  void initState() {
    super.initState();
    _fetchAdvocates();
    // Initialize all other controllers...
    _dtController = TextEditingController(text: widget.post['dt']);
    _sIlpClientController =
        TextEditingController(text: widget.post['s_ilpclient']);
    _sLegalOppController =
        TextEditingController(text: widget.post['s_legalopp']);
    _sAddressController = TextEditingController(text: widget.post['s_address']);
    _sEmailController = TextEditingController(text: widget.post['s_email']);
    _sPhoneController = TextEditingController(text: widget.post['s_phone']);
    _sNatureController = TextEditingController(text: widget.post['s_nature']);
    _sDocketController = TextEditingController(text: widget.post['s_docket']);
    _sCaseNumController = TextEditingController(text: widget.post['s_casenum']);
    _sSectionController = TextEditingController(text: widget.post['s_section']);
    _sNextDateController =
        TextEditingController(text: widget.post['s_next_date']);
    _sRemarksController = TextEditingController(text: widget.post['s_remarks']);
    _selectedStatus = widget.post['status'] ?? '';
    _selectedAdvocate =
        widget.post['s_attorny']; // Set initial advocate from the post
  }

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

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse(
            'https://api.indataai.in/wereads/addspeedsender.php?action=save_registerpost'),
        body: {
          'id': widget.post['id'].toString(),
          'dt': _dtController.text,
          's_ilpclient': _sIlpClientController.text,
          's_legalopp': _sLegalOppController.text,
          's_address': _sAddressController.text,
          's_email': _sEmailController.text,
          's_phone': _sPhoneController.text,
          's_nature': _sNatureController.text,
          's_docket': _sDocketController.text,
          's_casenum': _sCaseNumController.text,
          's_section': _sSectionController.text,
          's_attorny': _selectedAdvocate ?? '',
          'status': _selectedStatus,
          's_next_date': _sNextDateController.text,
          's_remarks': _sRemarksController.text,
          'roleSelector': _roleSelector,
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        Navigator.pop(context);
      } else {
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
      appBar: AppBar(title: const Text('Edit Post sender')),
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
              _buildTextField(_sDocketController, 'Docket'),
              _buildTextField(_sCaseNumController, 'Case Number'),
              _buildTextField(_sSectionController, 'Section'),
              // Remove this TextEditingController part and directly use the dropdown
              // _buildTextField(_selectedAdvocate as TextEditingController, 'Attorney'),
              _buildTextField(_sNextDateController, 'Next Date'),
              _buildTextField(_sRemarksController, 'Remarks'),
              // Advocate Dropdown
              DropdownButton<String?>(
                value: _selectedAdvocate,
                hint: const Text('Select Advocate'),
                onChanged: (value) {
                  setState(() {
                    _selectedAdvocate = value;
                  });
                },
                items: _advocateList.map<DropdownMenuItem<String?>>((advocate) {
                  return DropdownMenuItem<String?>(
                    value: advocate,
                    child: Text(advocate),
                  );
                }).toList(),
              ),
              // Status Dropdown
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

class PostDetailScreen1 extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen1({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Post Details', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Date: ${post['dt1']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Client: ${post['r_ilpclient']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Case No: ${post['r_legalopp']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('PHONE NUMBER: ${post['r_phone']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Status: ${post['status']}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  'Case No: ${post['r_casenum']}'), // Replace with the actual field you want
            ),
          ],
        ),
      ),
    );
  }
}
