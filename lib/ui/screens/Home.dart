import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tacgportal/data/models/active_member_db_info.dart';
import 'package:tacgportal/data/repositories/tacg_user_repository.dart';
import 'package:tacgportal/data/services/api/active_member_db_service.dart';
import 'package:tacgportal/router.dart';
import 'package:tacgportal/ui/widgets/basic_layout/mydrawer.dart';
import '../widgets/basic_layout/Header.dart';
import '../widgets/calendar.dart';
import '../widgets/calendar_event.dart';
import '../widgets/colorscheme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  

  @override
  Widget build(BuildContext context) {
    final TacgUserRepository userRepository =
        TacgUserRepository(); // Initialize the repository
    userRepository.getUsers().then((users) {
      print("Here are the users: $users");
    }).catchError((error) {
      print("Failed to fetch users: $error");
    });

    print(userRepository.getUsers());

    

    return const Scaffold(
      body: Row(
        children: [
          // Persistent Drawer
          Expanded(flex: 1, child: Mydrawer()),
          // Header + Main Content
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Header Section
                Expanded(
                  flex: 1,
                  child: HeaderWidget(),
                ),
                // Body Section
                Expanded(
                  flex: 5,
                  child: Calendar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// Navigator.push(
//                 context,
//                 MaterialPageRoute<ProfileScreen>(
//                   builder: (context) => ProfileScreen(
//                     appBar: AppBar(
//                       title: const Text('Profile'),
//                     ),
//                     actions: [
//                       SignedOutAction((context) {
//                         Navigator.of(context).pop();
//                       })
//                     ],
//                     children: [
//                       const Divider(),
//                       Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: AspectRatio(
//                           aspectRatio: 1,
//                           child: Image.asset('lib/assets/tacg-nbg.png'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
