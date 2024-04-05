// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(TaskApp());
// }
//
// class TaskApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Project Management App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TaskAssignmentScreen(),
//     );
//   }
// }
//
// class TaskAssignmentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Assign Task'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Enter task',
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Text('Select Deadline: '),
//                 TextButton(
//                   onPressed: () {
//                     // Implement deadline selection functionality here
//                   },
//                   child: Text('Set Deadline'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement assign task functionality here
//               },
//               child: Text('Assign Task'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement view task list functionality here
//               },
//               child: Text('View Task List'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TaskListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task List'),
//       ),
//       body: Center(
//         child: Text('Task List Screen'),
//       ),
//     );
//   }
// }
//
// class TaskTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text('Task Title'),
//       subtitle: Text('Task Deadline'),
//       trailing: Checkbox(
//         value: false,
//         onChanged: null,
//       ),
//     );
//   }
// }
