import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/DrawerItem.dart';
import '../widgets/Header.dart';
import '../widgets/calendar.dart';
import '../widgets/calendar_event.dart';
import '../widgets/colorscheme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Row(
        children: [
          // Persistent Drawer
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3)),
                    child: Drawer(
                      // Do not explicitly set backgroundColor; observe automatic behavior
                      child: ListView(
                        children: [
                          DrawerHeader(
                            child: Center(
                              child: Image.asset(
                                "lib/assets/tacg-nbg.png",
                                width: 300,
                              ),
                            ),
                          ),
                          const DrawerItem(
                            title: 'Dashboard',
                            icon: Icons.dashboard,
                            route: '/',
                          ),
                          const DrawerItem(
                            title: 'Orders',
                            icon: Icons.shopping_cart,
                            route: '/',
                          ),
                          const DrawerItem(
                            title: 'Products',
                            icon: Icons.shopping_bag,
                            route: '/',
                          ),
                          const DrawerItem(
                            title: 'Customers',
                            icon: Icons.people,
                            route: '/customers',
                          ),
                          const DrawerItem(
                            title: 'Reports',
                            icon: Icons.bar_chart,
                            route: '/reports',
                          ),
                          const DrawerItem(
                            title: 'Promotions',
                            icon: Icons.local_offer,
                            route: '/promotions',
                          ),
                          const DrawerItem(
                            title: 'Settings',
                            icon: Icons.settings,
                            route: '/settings',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Header + Main Content
          const Expanded(
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
