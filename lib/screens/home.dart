import 'package:flutter/material.dart';
import 'package:individualactivity2/screens/edit_student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _students = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://testing-backend-wnrj.onrender.com/api/students'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _students = json.decode(response.body);
      });
    } else {
      print('Failed to load data');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response = await http.delete(
      Uri.parse('https://testing-backend-wnrj.onrender.com/api/students/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _students.removeWhere((student) => student['_id'] == id);
      });
    } else {
      print('Failed to delete student');
    }
  }

  void editStudent(Map<String, dynamic> student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );

    if (result ?? false) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Student List'),
      ),
      body: _students.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                String id = _students[index]['_id'] ?? '';
                String firstName = _students[index]['Firstname'] ?? '';
                String lastName = _students[index]['Lastname'] ?? '';
                String year = _students[index]['Year'] ?? 'Unknown';
                String course = _students[index]['Course'] ?? 'Unknown';
                bool enrolled = _students[index]['Enrolled'] ?? false;

                return Dismissible(
                  key: Key(id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    deleteStudent(id);
                  },
                  child: GestureDetector(
                    onTap: () => editStudent(_students[index]),
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$firstName $lastName',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Year: $year, Course: $course'),
                            Row(
                              children: [
                                Text(
                                  enrolled ? 'Enrolled' : 'Not Enrolled',
                                  style: TextStyle(
                                    color: enrolled ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                enrolled
                                    ? const Icon(Icons.check, color: Colors.green)
                                    : const Icon(Icons.close, color: Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
