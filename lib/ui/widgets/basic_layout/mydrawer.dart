import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          child: Drawer(
            // Do not explicitly set backgroundColor; observe automatic behavior
            child: FutureBuilder<DocumentSnapshot>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                String userRole = 'member'; // Default to member
                if (snapshot.hasData && snapshot.data!.exists) {
                  userRole = (snapshot.data!.data() as Map<String, dynamic>?)?['role'] as String? ?? 'member';
                }

                return ListView(
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
                    // Admin-only items
                    if (userRole == 'admin') ...[
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
                      
                    ],
                    // Member items (shown to both members and admins)
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
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<DocumentSnapshot> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    }
    throw Exception('No user logged in');
  }
}