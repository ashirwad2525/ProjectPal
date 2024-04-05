import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskAssignmentScreen(),
        '/task_list': (context) => TaskListScreen(),
      },
    );
  }
}

class TaskAssignmentScreen extends StatefulWidget {
  @override
  _TaskAssignmentScreenState createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  String? task;
  DateTime? deadline;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
  }

  Future<void> checkAdminStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        Map<String, dynamic>? userDataMap = userData.data() as Map<String, dynamic>?; // Explicit cast
        if (userDataMap != null) {
          setState(() {
            isAdmin = userDataMap['isAdmin'] ?? false;
          });
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                task = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter task',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Select Deadline: '),
                TextButton(
                  onPressed: () {
                    _selectDeadline(context);
                  },
                  child: Text(
                    deadline != null ? DateFormat('yyyy-MM-dd HH:mm').format(deadline!) : 'Set Deadline',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAdmin ? () => _assignTask(context) : null,
              child: Text('Assign Task'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task_list');
              },
              child: Text('View Task List'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          deadline = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  void _assignTask(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    FirebaseFirestore.instance.collection('tasks').add({
      'title': task,
      'deadline': deadline,
      'completed': false,
      'adminEmail': userEmail,
    }).then((docRef) {
      print('Task assigned successfully: $task');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task assigned successfully')),
      );
    }).catchError((error) {
      print('Failed to assign task: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign task')),
      );
    });
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<TaskTile> taskTiles = [];
          snapshot.data!.docs.forEach((doc) {
            Task task = Task.fromSnapshot(doc);
            taskTiles.add(TaskTile(task: task));
          });

          return ListView(
            children: taskTiles,
          );
        },
      ),
    );
  }
}

class Task {
  final String title;
  final DateTime? deadline;
  bool completed;
  final String adminEmail;

  Task({required this.title, this.deadline, this.completed = false, required this.adminEmail});

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        deadline = snapshot['deadline'] != null ? (snapshot['deadline'] as Timestamp).toDate() : null,
        completed = snapshot['completed'],
        adminEmail = snapshot['adminEmail'];
}

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.deadline != null ? 'Deadline: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline!)}' : 'No Deadline'),
      trailing: Checkbox(
        value: task.completed,
        onChanged: (bool? value) {
          _updateTaskCompletion(context, task, value!);
        },
      ),
    );
  }

  void _updateTaskCompletion(BuildContext context, Task task, bool value) {
    task.completed = value;

    FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.title) // Using title as Document ID
        .update({'completed': value})
        .then((_) {
      print('Task completion status updated successfully: ${task.title}');
    }).catchError((error) {
      print('Failed to update task completion status: $error');
    });
  }
}
