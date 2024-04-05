import 'package:flutter/material.dart';
import 'package:collab3/Team/create_team.dart'; // Import the CreateTeam widget
import 'package:collab3/Team/join_team.dart'; // Import the JoinTeam widget

class Lets extends StatefulWidget {
  const Lets({Key? key}) : super(key: key);

  @override
  State<Lets> createState() => _LetsState();
}

class _LetsState extends State<Lets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/lets.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Your content goes here
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateTeam()),
                      );
                    },
                    child: Text('Create a Team'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JoinTeam()),
                      );
                    },
                    child: Text('Join a Team'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
