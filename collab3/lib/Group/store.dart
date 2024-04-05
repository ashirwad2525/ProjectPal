import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class MyStorage extends StatefulWidget {
  const MyStorage({Key? key}) : super(key: key);

  @override
  State<MyStorage> createState() => _MyStorageState();
}

class _MyStorageState extends State<MyStorage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> uploadedItems = [];

  @override
  void initState() {
    super.initState();
    // Load the uploaded items from Firestore when the widget initializes
    _loadUploadedItems();
  }

  Future<void> _loadUploadedItems() async {
    // Get the current user's email
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    // Retrieve the uploaded items from Firestore for the current user
    QuerySnapshot snapshot = await firestore.collection('uploaded_items')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    setState(() {
      // Extract the download URLs from the snapshot and store them in the list
      uploadedItems = snapshot.docs.map<String>((doc) => doc['url'] as String).toList();
    });
  }

  Future<String?> _uploadFile(String filePath) async {
    File file = File(filePath);
    String fileName = path.basename(file.path);
    try {
      UploadTask uploadTask = storage.ref('uploads/$fileName').putFile(file);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Uploading File...'),
                StreamBuilder<TaskSnapshot>(
                  stream: uploadTask.snapshotEvents,
                  builder: (context, snapshot) {
                    var progress = 0.0;
                    if (snapshot.hasData) {
                      progress = snapshot.data!.bytesTransferred / snapshot.data!.totalBytes;
                    }
                    return LinearProgressIndicator(value: progress);
                  },
                ),
              ],
            ),
          );
        },
      );

      TaskSnapshot snapshot = await uploadTask;
      Navigator.pop(context); // Dismiss the dialog
      String downloadURL = await snapshot.ref.getDownloadURL();
      print('File uploaded successfully: $downloadURL');

      // Get the current user's email
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      // Save the download URL to Firestore along with the user's email for persistence
      await firestore.collection('uploaded_items').add({
        'url': downloadURL,
        'userEmail': userEmail,
      });
      setState(() {
        uploadedItems.add(downloadURL); // Add the uploaded item to the list
      });
      return downloadURL;
    } catch (error) {
      print('Error uploading file: $error');
      return null;
    }
  }

  Widget _buildFilePreview(String url) {
    String extension = path.extension(url).toLowerCase();
    if (extension == '.jpg' || extension == '.jpeg' || extension == '.png') {
      return Image.network(
        url,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(Icons.insert_drive_file, size: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Storage'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/blrbg2.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: uploadedItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await launch(uploadedItems[index]);
                      },
                      child: ListTile(
                        leading: _buildFilePreview(uploadedItems[index]),
                        title: Text('File ${index + 1}'),
                        // You can add more details or actions here if needed
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Open file picker
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    String? filePath = result.files.single.path;
                    if (filePath != null) {
                      // File picked
                      print('File picked: $filePath');
                      // Upload file to Firebase Storage
                      await _uploadFile(filePath);
                    }
                  } else {
                    // User canceled the file picker
                    print('User canceled file picker');
                  }
                },
                child: Text('Select File'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(200.0, 50.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyStorage(),
  ));
}
