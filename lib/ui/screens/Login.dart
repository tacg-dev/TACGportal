import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tacgportal/router.dart';
import 'package:tacgportal/ui/screens/Home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        // Your existing action
        AuthStateChangeAction<SignedIn>((context, state) {
          if (state.user != null) {
            print('User signed in: ${state.user!.email} ${state.user!.uid}');
            context.goNamed(AppRoute.home.name);
          }
        }),
        // Add this to handle register link click
        AuthStateChangeAction<AuthFailed>((context, state) {
          print('Auth failed: ${state.exception}');
        }),
      ],
      // Set this to false to handle register navigation yourself
      showAuthActionSwitch: false,
      // Add a custom footer with your own register link
      footerBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () => context.goNamed(AppRoute.register.name),
                child: const Text("Register"),
              ),
            ],
          ),
        );
      },
      sideBuilder: (context, shrinkOffset) {
        // Your existing side builder
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('lib/assets/tacg-nbg.png'),
          ),
        );
      },
    );
  }
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
      actions: [
        // This fires when a user account is created
        AuthStateChangeAction<UserCreated>((context, state) {
          if (state.credential != null) {
            // Create user entry in Firestore
            createUserInFirestore(state.credential!.user!.uid, state.credential.user!);
            // Navigate to home screen
            context.goNamed(AppRoute.home.name);
          }
        }),
        // This fires when user is fully signed in
        AuthStateChangeAction<SignedIn>((context, state) {
          if (state.user != null) {
            print(
                'User registered and signed in: ${state.user!.email} ${state.user!.uid}');
            context.goNamed(AppRoute.home.name);
          }
        }),
      ],
      showAuthActionSwitch: false,
      footerBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                onPressed: () => context.goNamed(AppRoute.login.name),
                child: const Text("Sign in"),
              ),
            ],
          ),
        );
      },
      // You can customize the UI similar to your Login widget
      sideBuilder: (context, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('lib/assets/tacg-nbg.png'),
          ),
        );
      },
    );
  }

  // Function to create user in Firestore
  void createUserInFirestore(String uid, User user) async {
    try {
      
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'approved' : false,
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'role': 'member',
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
          // Add any other user fields you want to store
        },
      );
      print('User document created in Firestore');
    } catch (e) {
      print('Error creating user document: $e');
    }
  }
}
