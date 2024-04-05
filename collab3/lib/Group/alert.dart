import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:collab3/screen/home_screen.dart'; // Import your home screen file
import 'package:collab3/Group/meeting_database.dart'; // Import your meeting page file
import 'package:collab3/screen/teammss.dart'; // Import your task page file
import 'package:cloud_firestore/cloud_firestore.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  late String latestTask = ''; // Provide initial value
  late String latestMeeting = ''; // Provide initial value
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchLatestData();
  }

  void fetchLatestData() async {
    try {
      // Fetch latest task
      final QuerySnapshot taskSnapshot = await FirebaseFirestore.instance.collection('tasks').orderBy('createdAt', descending: true).limit(1).get();
      final List<DocumentSnapshot> taskDocs = taskSnapshot.docs;
      final String latestTaskTitle = taskDocs.isNotEmpty ? (taskDocs.first.data() as Map)['title'] : 'No task yet';

      // Fetch latest meeting
      final QuerySnapshot meetingSnapshot = await FirebaseFirestore.instance.collection('meetings').orderBy('scheduledDateTime', descending: true).limit(1).get();
      final List<DocumentSnapshot> meetingDocs = meetingSnapshot.docs;
      final String latestMeetingDetails = meetingDocs.isNotEmpty ? (meetingDocs.first.data() as Map)['meetingDetails'] : 'No meeting yet';

      setState(() {
        latestTask = latestTaskTitle;
        latestMeeting = latestMeetingDetails;
        dataLoaded = true; // Set dataLoaded to true to indicate data is loaded
      });
    } catch (error) {
      print('Error fetching latest data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: GNav(
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              GButton(
                icon: Icons.notifications,
                text: 'Alerts',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: 1, // Assuming this is the Alerts tab, change it accordingly
            onTabChange: (index) {
              // Handle tab changes if needed
            },
            color: Colors.lime.shade200,
            activeColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dataLoaded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Task: $latestTask',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Latest Meeting: $latestMeeting',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            if (!dataLoaded)
              Center(
                child: CircularProgressIndicator(), // Show loading indicator while data is being fetched
              ),
          ],
        ),
      ),
    );
  }
}
