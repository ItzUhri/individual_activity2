import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditStudentScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const EditStudentScreen({super.key, required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _courseController;
  late String _year;
  late bool _enrolled;

  final List<String> _yearOptions = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year'
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student['firstname']);
    _lastNameController =
        TextEditingController(text: widget.student['lastname']);
    _courseController = TextEditingController(text: widget.student['course']);
    _year = widget.student['year'] ?? 'First Year';
    _enrolled = widget.student['enrolled'] ?? false;
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.put(
        Uri.parse(
            'https://testing-backend-wnrj.onrender.com/api/students/${widget.student['_id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Firstname': _firstNameController.text,
          'Lastname': _lastNameController.text,
          'Year': _year,
          'Course': _courseController.text,
          'Enrolled': _enrolled,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        print('Failed to update student');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Edit Student'), centerTitle: true,),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_firstNameController, 'First Name'),
              _buildTextField(_lastNameController, 'Last Name'),
              _buildDropdownField(),
              _buildTextField(_courseController, 'Course'),
              SwitchListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (value) => setState(() => _enrolled = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStudent,
                child: const Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _year,
      decoration: const InputDecoration(labelText: 'Year'),
      items: _yearOptions
          .map((year) => DropdownMenuItem(value: year, child: Text(year)))
          .toList(),
      onChanged: (newValue) => setState(() => _year = newValue ?? 'First Year'),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a year' : null,
    );
  }
}
