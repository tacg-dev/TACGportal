import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fbuiauth;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacgportal/data/models/active_member_db_info.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';
import 'package:tacgportal/data/services/api/active_member_db_service.dart';
import 'package:tacgportal/firebase_options.dart';
import 'package:tacgportal/data/providers/calendar_provider.dart';
import 'package:tacgportal/data/repositories/calendar_repository.dart';
import 'package:tacgportal/router.dart';
import 'package:tacgportal/data/services/api/calendar_api_service.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;

void testApi() async {
  var url = Uri.parse("https://web-backend.vercel.app/api/calendar-events");
  try {
    print("HEEEEEE");
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}

void main() async {
  

  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize Firebase with options
  );

  fbuiauth.FirebaseUIAuth.configureProviders(
    [
      fbuiauth.EmailAuthProvider(),
      GoogleProvider(
          clientId:
              "9882828577-h91224r70ucom5ii6dql6981dqrfo027.apps.googleusercontent.com")
    ],

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 
    TextTheme systemTextTheme = ThemeData.light().textTheme;
    MaterialTheme theme = MaterialTheme(systemTextTheme);
    // ColorScheme colorScheme = MaterialTheme.lightScheme();
    final router = goRouter;

    return MultiProvider(
      providers: [
        Provider(
          create: (_) => CalendarApiService(
              baseUrl: "https://web-backend.vercel.app/api/calendar-events"),
        ),
        ProxyProvider<CalendarApiService, CalendarRepository>(
          update: (_, apiService, __) =>
              CalendarRepository(calendarApiService: apiService),
        ),
        ChangeNotifierProxyProvider<CalendarRepository, CalendarProvider>(
          create: (context) => CalendarProvider(
            Provider.of<CalendarRepository>(context, listen: false),
          ),
          update: (_, repository, __) => CalendarProvider(repository),
        ),

        Provider<TacgEventRepository>(
          create: (_) => TacgEventRepository(),
        ),
        
        
      ],
      child: MaterialApp.router(
        title: "Main App",
        theme: theme.light(),
        darkTheme: theme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
