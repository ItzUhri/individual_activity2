
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _year = '';
  String _course = '';
  bool _enrolled = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare the data
      final Map<String, dynamic> formData = {
        'Firstname': _firstName,
        'Lastname': _lastName,
        'Year': _year,
        'Course': _course,
        'Enrolled': _enrolled,
      };

      // Send data to the local API
      final response = await http.post(
        Uri.parse('https://testing-backend-wnrj.onrender.com/api/students'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Form submitted successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to submit form');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              onSaved: (value) {
                _firstName = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Last Name'),
              onSaved: (value) {
                _lastName = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Year'),
              items: const [
                DropdownMenuItem(value: 'First Year', child: Text('First Year')),
                DropdownMenuItem(value: 'Second Year', child: Text('Second Year')),
                DropdownMenuItem(value: 'Third Year', child: Text('Third Year')),
                DropdownMenuItem(value: 'Fourth Year', child: Text('Fourth Year')),
                DropdownMenuItem(value: 'Fifth Year', child: Text('Fifth Year')),
              ],
              onChanged: (value) {
                setState(() {
                  _year = value!;
                });
              },
              onSaved: (value) {
                _year = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your academic year';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Course'),
              onSaved: (value) {
                _course = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your course';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: const Text('Enrolled'),
              value: _enrolled,
              onChanged: (bool value) {
                setState(() {
                  _enrolled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
