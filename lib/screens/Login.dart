import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tacgportal/router.dart';
import 'package:tacgportal/screens/Home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) {
            if (state.user != null) {
              print('User signed in: ${state.user!.email} ${state.user!.uid}');



              print(FirebaseAuth.instance.authStateChanges());

              context.goNamed(AppRoute.home.name);
              
            }
          },
        ),
      ],
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
}
