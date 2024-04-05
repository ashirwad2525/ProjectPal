import 'dart:math';
import 'package:collab3/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    home: CreateTeam(),
  ));
}

class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _projectDescriptionController = TextEditingController();
  List<TextEditingController> _teamMemberControllers = [];

  String? _teamId;
  late String _teamCode = '';
  bool _teamCreated = false;

  @override
  void initState() {
    super.initState();
    _teamMemberControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _projectDescriptionController.dispose();
    _teamMemberControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/blrbg2.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Team Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _teamNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your team name',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Project Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _projectDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter your project description',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Team Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _teamMemberControllers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _teamMemberControllers[index],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Enter team member name',
                          border: InputBorder.none,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _teamMemberControllers.add(TextEditingController());
                    });
                  },
                  child: Text('Add Team Member'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _createTeam();
                  },
                  child: Text('Create Team'),
                ),
                SizedBox(height: 20),
                _teamId != null ? Text('Team ID: $_teamId') : Container(),
                SizedBox(height: 10),
                _teamCode.isNotEmpty ? Text('Team Code: $_teamCode') : Container(),
                SizedBox(height: 20),
                _teamCreated
                    ? IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createTeam() async {
    try {
      _generateTeamCode();
      CollectionReference teams = FirebaseFirestore.instance.collection('teams');
      DocumentReference docRef = await teams.add({
        'teamName': _teamNameController.text,
        'projectDescription': _projectDescriptionController.text,
        'teamMembers': _teamMemberControllers.map((controller) => controller.text).toList(),
        'teamCode': _teamCode,
      });
      String teamId = docRef.id;
      setState(() {
        _teamId = teamId;
        _teamCreated = true;
      });

      // Get the current user's email
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      // Save the user's email to the admin section
      await FirebaseFirestore.instance.collection('admin').doc(teamId).set({
        'adminEmail': userEmail,
      });

      // Replace 'user_id' with the actual user ID
      String userId = 'user_id';
      await FirebaseFirestore.instance.collection('userGroups').doc(userId).update({
        'groups': FieldValue.arrayUnion([teamId]),
      });

      _showTeamIdDialog(teamId);
    } catch (e) {
      print('Error creating team: $e');
    }
  }

  void _generateTeamCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    const length = 6;
    _teamCode = List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _showTeamIdDialog(String teamId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Team ID'),
          content: Text('Your team ID is: $teamId'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to Home Screen!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
