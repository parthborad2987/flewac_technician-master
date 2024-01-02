// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/tab_provider.dart';
// import 'attendance_punchin.dart';
// import 'job_screen.dart';
// import 'profile_screen.dart';
// import 'salary_screen.dart';
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key,});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Consumer<TabProvider>(
//           builder: (context, tabProvider,_) {
//             return BottomNavigationBar(
//                 selectedItemColor: Colors.black,
//                 unselectedItemColor: Colors.white,
//                 currentIndex: tabProvider.selectedTab,
//                 onTap: (index) {
//                   tabProvider.selectedTab = index;
//                 },
//                 items: const [
//                   BottomNavigationBarItem(icon: Icon(Icons.home),
//                       label: "",backgroundColor: Color(0xFF00B0FF)),
//                   BottomNavigationBarItem(icon: Icon(Icons.search),
//                       label: "",backgroundColor: Color(0xFF00B0FF)),
//                   BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded),
//                       label: "",backgroundColor: Color(0xFF00B0FF)),
//                   BottomNavigationBarItem(icon: Icon(Icons.person),
//                       label: "",backgroundColor: Color(0xFF00B0FF)),
//                 ]);
//           }),
//
//       body: Consumer<TabProvider>(
//         builder: (context, tabProvider, _) {
//           return IndexedStack(
//             index: tabProvider.selectedTab,
//             children: const [
//               // Add your different pages here
//               Job(),
//               Salary(),
//               Attendance(),
//               Profile(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }