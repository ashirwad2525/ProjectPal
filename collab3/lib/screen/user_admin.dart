import 'package:flutter/material.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({Key? key}) : super(key: key);

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Admin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to sign up as admin screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage(userType: 'Admin')),
                );
              },
              child: Text('Sign Up as Admin'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to sign up as user screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage(userType: 'User')),
                );
              },
              child: Text('Sign Up as User'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  final String userType;

  const SignUpPage({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up as $userType'),
      ),
      body: Center(
        child: Text('Sign Up as $userType'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserAdmin(),
  ));
}
