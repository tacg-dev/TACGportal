import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tacgportal/ui/screens/ActiveMembers.dart';
import 'package:tacgportal/ui/screens/AdminAttendance.dart';
import 'package:tacgportal/ui/screens/AdminEvents.dart';
import 'package:tacgportal/ui/screens/Home.dart';
import 'package:tacgportal/ui/screens/Login.dart';
import 'package:tacgportal/theme.dart';
import 'package:tacgportal/ui/screens/Statistics.dart';
import 'package:tacgportal/ui/screens/SubmitAttendance.dart';
import 'package:tacgportal/ui/screens/TestData.dart';
import 'package:tacgportal/ui/widgets/colorscheme.dart';
import 'package:tacgportal/ui/widgets/not_approved.dart';

enum AppRoute {
  login,
  home,
  testy,
  color,
  adminevents,
  adminattendance,
  register,
  notapproved,
  testdata,
  statistics,
  submitattendance,
  activemembers,
}

ColorScheme colorScheme = MaterialTheme.lightScheme();
GoRouter goRouter = GoRouter(
  redirect: (context, state) async {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final bool isGoingToLogin = state.uri.path == '/login';
    final bool isGoingToRegister = state.uri.path == '/register';
    final bool isGoingToNotApproved = state.uri.path == '/notapproved';

    if (isGoingToRegister || isGoingToLogin) {
      if (isLoggedIn) {
        await FirebaseAuth.instance.signOut();
      }
      return null;
    }

    if (!isLoggedIn && !isGoingToLogin) {
      return '/login?redirect=${state.uri.path}';
    }

    if (isLoggedIn) {
      if (!isGoingToNotApproved) {
        try {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          final bool isApproved = userDoc.data()?['approved'] ?? false;

          if (!isApproved) {
            return '/notapproved';
          }
        } catch (e) {
          // Handle the error appropriately, e.g., log it or show a message
          print('Error fetching user approval status: $e');
        }
      }

      return null;
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/home',
      name: AppRoute.home.name,
      builder: (context, state) {
        return const Home();
      },
    ),
    GoRoute(
      path: '/color',
      name: AppRoute.color.name,
      builder: (context, state) {
        return ColorSchemeDisplay(colorScheme: colorScheme);
      },
    ),
    GoRoute(
      path: '/adminevents',
      name: AppRoute.adminevents.name,
      builder: (context, state) {
        return const AdminEvents();
      },
    ),
    GoRoute(
      path: '/register',
      name: AppRoute.register.name,
      builder: (context, state) {
        return const Register();
      },
    ),
    GoRoute(
      path: '/notapproved',
      name: AppRoute.notapproved.name,
      builder: (context, state) {
        return const NotApproved();
      },
    ),
    GoRoute(
      path: '/testdata',
      name: AppRoute.testdata.name,
      builder: (context, state) {
        return const Testdata();
      },
    ),
    GoRoute(
      path: '/adminattendance',
      name: AppRoute.adminattendance.name,
      builder: (context, state) {
        return const Adminattendance();
      },
    ),
    GoRoute(
      path: '/statistics',
      name: AppRoute.statistics.name,
      builder: (context, state) {
        return const Statistics();
      },
    ),
    GoRoute(
      path: '/submitattendance',
      name: AppRoute.submitattendance.name,
      builder: (context, state) {
        return const Submitattendance();
      },
    ),
    GoRoute(
        path: '/activemembers',
        name: 'activemembers',
        builder: (context, state) {
          return const ActiveMembersPage();
        }),
  ],
);
