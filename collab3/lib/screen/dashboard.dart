// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.transparent,
//     body: Stack(
//       fit: StackFit.expand,
//       children: [
//         Image.asset(
//           'assets/blrcode1.jpg',
//           fit: BoxFit.cover,
//         ),
//         SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 45, left: 20),
//                 child: Text(
//                   'Hi,',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                     shadows: [
//                       BoxShadow(color: Colors.black38, blurRadius: 3)
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, bottom: 27),
//                 child: Text(
//                   'First Name',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                     shadows: [
//                       BoxShadow(color: Colors.black38, blurRadius: 3)
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15, bottom: 20, right: 200),
//                 child: GestureDetector(
//                   onTap: () {
//                     _showNoteDialog(context);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.note_add,
//                           color: Colors.yellow,
//                         ),
//                         SizedBox(width: 5),
//                         Text(
//                           'Add Note',
//                           style: TextStyle(color: Colors.grey[100]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: _notes
//                     .map(
//                       (note) =>
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, bottom: 5),
//                         child: Text(
//                           note,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                 )
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 220, top: 1),
//             child: Container(
//               height: 95, // Adjust height as needed
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   SizedBox(width: 3),
//                   // Add initial padding
//                   GestureDetector(
//                     onTap: () {
//                       _onNavItemTapped(0);
//                     },
//                     child: _buildTeamCard('Teams', Colors.black45),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _onNavItemTapped(1);
//                     },
//                     child: _buildTeamCard('Meeting', Colors.black45),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _onNavItemTapped(2);
//                     },
//                     child: _buildTeamCard('Task', Colors.black45),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//     floatingActionButton: BottomNavBar(
//       selectedIndex: _selectedIndex,
//       onTabChange: _onNavItemTapped,
//     ),
//   );
// }
