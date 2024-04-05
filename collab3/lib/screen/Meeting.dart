import 'package:collab3/Group/meeting_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab3/Group/meeting_database.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({Key? key}) : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  TextEditingController _meetingDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/blrbg2.jpg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50), // Adding space from top
                    Text(
                      'Schedule Meeting',
                      style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30), // Adding space between title and content
                    _buildDateTimeSelection('Select Date:', '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}', _pickDate),
                    SizedBox(height: 16),
                    _buildDateTimeSelection('Select Time:', '${_selectedTime.hour}:${_selectedTime.minute}', _pickTime),
                    SizedBox(height: 16),
                    _buildMeetingDetailsInput(),
                    SizedBox(height: 30), // Adding space between content and button
                    ElevatedButton(
                      onPressed: _scheduleMeeting,
                      child: Text('Schedule Meeting'),
                    ),
                    SizedBox(height: 20), // Adding space below the button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MeetingDatabase()),
                        );
                      },
                      child: Text('My Meetings'),
                    ),
                    SizedBox(height: 20), // Adding space below the "My Meetings" button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection(String label, String value, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMeetingDetailsInput() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextField(
          controller: _meetingDetailsController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Enter meeting details',
            border: InputBorder.none,
          ),
          maxLines: 4,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _scheduleMeeting() {
    final DateTime scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final String meetingDetails = _meetingDetailsController.text;

    print('Meeting scheduled for: $scheduledDateTime');
    print('Meeting details: $meetingDetails');

    // Storing meeting data in Firestore
    FirebaseFirestore.instance.collection('meetings').add({
      'scheduledDateTime': scheduledDateTime,
      'meetingDetails': meetingDetails,
    });
  }

  @override
  void dispose() {
    _meetingDetailsController.dispose();
    super.dispose();
  }
}
