import 'package:collab3/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class JoinTeam extends StatefulWidget {
  const JoinTeam({Key? key});

  @override
  State<JoinTeam> createState() => _JoinTeamState();
}

class _JoinTeamState extends State<JoinTeam> {
  TextEditingController _teamCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Team'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/team.jpg', // Background image
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Team Code:',
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  child: TextField(
                    controller: _teamCodeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Team Code',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Validate the entered team code
                    bool isValidCode = await _validateTeamCode(_teamCodeController.text);
                    if (isValidCode) {
                      // Associate user with the joined team as a regular user
                      await _associateUserWithTeam(_teamCodeController.text);

                      // Navigate to the TaskList screen to view tasks assigned to the team
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } else {
                      // Show an error message for invalid team code
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid Team code. Please try again.'),
                        ),
                      );
                    }
                  },
                  child: Text('Join Team'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _validateTeamCode(String code) async {
    try {
      // Query Firestore to check if the entered code exists in the teams collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('teams').where('teamCode', isEqualTo: code).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error validating Team code: $e');
      return false;
    }
  }

  Future<void> _associateUserWithTeam(String teamCode) async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        // Add the user to the team with role 'USER'
        await FirebaseFirestore.instance.collection('teams').doc(teamCode).collection('members').doc(userEmail).set({
          'role': 'USER',
        });
      } else {
        print('User email is null');
        // Handle the case where user email is null
      }
    } catch (e) {
      print('Error associating user with team: $e');
      // Handle error as needed
    }
  }
}

class TaskListScreen extends StatelessWidget {
  final String teamCode;

  TaskListScreen({required this.teamCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('teams').doc(teamCode).collection('tasks').snapshots(),
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
      subtitle: Text(task.deadline != null ? 'Deadline: ${DateFormat('yyyy-MM-dd').format(task.deadline!)}' : 'No Deadline'),
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
        .collection('teams')
        .doc(task.adminEmail) // Using admin email as Document ID
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
