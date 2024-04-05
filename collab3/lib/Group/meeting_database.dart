import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingDatabase extends StatelessWidget {
  const MeetingDatabase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Meetings'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('meetings').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Meetings Scheduled'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var meeting = snapshot.data!.docs[index];
              var scheduledDateTime = meeting['scheduledDateTime'];
              var meetingDetails = meeting['meetingDetails'];
              return ListTile(
                title: Text('Meeting Date & Time: ${scheduledDateTime.toDate()}'),
                subtitle: Text('Meeting Details: $meetingDetails'),
              );
            },
          );
        },
      ),
    );
  }
}
