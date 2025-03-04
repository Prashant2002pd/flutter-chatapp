import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:test3/firebase_options.dart';
import 'package:test3/pages/Settings.dart';
import 'package:test3/pages/blocked_users_page.dart';
import 'package:test3/pages/login.dart';
import 'package:test3/pages/profile.dart';
import 'package:test3/pages/signup.dart';
import 'package:test3/pages/homepage.dart';
import 'package:test3/themes/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: '.env');


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child:const MyApp()
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home:FirebaseAuth.instance.currentUser != null? Homepage(): Login(),
      routes: {
        '/login': (context) => Login(),
        'signUp': (context) => Signup(),
        '/profile': (context) => Profile(),
        '/Home': (context) => Homepage(),
        '/settings': (context) => SettingsPage(),
        '/blocked_users': (context) => BlockedUsersPage(),
      },
    );
  }
}

