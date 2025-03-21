import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fbuiauth;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/firebase_options.dart';
import 'package:tacgportal/screens/Login.dart';
import 'package:tacgportal/util.dart';
import 'package:tacgportal/widgets/colorscheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_page.dart';
import 'screens/test.dart';
import 'screens/Home.dart';
import 'theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize Firebase with options
  );

  fbuiauth.FirebaseUIAuth.configureProviders([
    fbuiauth.EmailAuthProvider(),
    GoogleProvider(
        clientId:
            "9882828577-h91224r70ucom5ii6dql6981dqrfo027.apps.googleusercontent.com")
  ]);
  runApp(const MyApp());
}

// Global function to handle sign out
Future<void> handleSignOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // Force rebuild from root by popping to first route
  // and letting the StreamBuilder handle the rest
  Navigator.of(context).popUntil((route) => route.isFirst);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme systemTextTheme = ThemeData.light().textTheme;
    MaterialTheme theme = MaterialTheme(systemTextTheme);
    ColorScheme colorScheme = MaterialTheme.lightScheme();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            title: "Login",
            theme: theme.light(),
            darkTheme: theme.dark(),
            themeMode: ThemeMode.system,
            routes: {
              "/": (context) => fbuiauth.SignInScreen(
                    actions: [
                      fbuiauth.AuthStateChangeAction<fbuiauth.SignedIn>(
                        (context, state) {
                          if (state.user != null) {
                            print(
                                'User signed in: ${state.user!.email} ${state.user!.uid}');

                            print(FirebaseAuth.instance.authStateChanges());
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
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
                  ),
            },
          );
        }

        return MaterialApp(
          title: "Main App",
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: ThemeMode.system,
          routes: {
            "/": (context) => const Home(),
            "/testy": (context) => const TestPage(),
            "/color": (context) => ColorSchemeDisplay(colorScheme: colorScheme),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/testy");
              },
              child: const Text("Go to test page"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/color"),
              child: const Text("Go to color page"),
            ),
          ],
        ),
      ),
    );
  }

  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
}
