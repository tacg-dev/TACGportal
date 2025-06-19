import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/ui/widgets/basic_layout/DrawerItem.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    title: 'Home',
                    icon: Icons.home,
                    route: '/home',
                  ),
                  const DrawerItem(
                    title: 'Admin Events',
                    icon: Icons.dashboard,
                    route: '/adminevents',
                  ),
                  const DrawerItem(
                    title: 'Admin Attendance',
                    icon: Icons.groups,
                    route: '/adminattendance',
                  ),
                  const DrawerItem(
                      title: "Statistics",
                      icon: Icons.analytics,
                      route: '/statistics'),
                  const DrawerItem(
                    title: "Submit Attendance",
                    icon: Icons.check_circle,
                    route: '/submitattendance',
                  ),
                  const DrawerItem(
                    title: 'Active Members',
                    icon: Icons.people,
                    route: '/activemembers',
                  ),
                  // const DrawerItem(
                  //   title: 'Orders',
                  //   icon: Icons.shopping_cart,
                  //   route: '/',
                  // ),
                  // const DrawerItem(
                  //   title: 'Products',
                  //   icon: Icons.shopping_bag,
                  //   route: '/',
                  // ),
                  // const DrawerItem(
                  //   title: 'Customers',
                  //   icon: Icons.people,
                  //   route: '/customers',
                  // ),
                  // const DrawerItem(
                  //   title: 'Reports',
                  //   icon: Icons.bar_chart,
                  //   route: '/reports',
                  // ),
                  // const DrawerItem(
                  //   title: 'Promotions',
                  //   icon: Icons.local_offer,
                  //   route: '/promotions',
                  // ),
                  // const DrawerItem(
                  //   title: 'Settings',
                  //   icon: Icons.settings,
                  //   route: '/settings',
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
