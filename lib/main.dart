import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_complete_guide/providers/finishedprovider.dart';
import 'package:flutter_complete_guide/providers/socialprovider.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_complete_guide/providers/authprovider.dart';
import 'package:flutter_complete_guide/providers/usertaskprovider.dart';

import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

import 'providers/todoprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TaskProvider1(),
        ),
        ChangeNotifierProvider.value(
          value: TodoProvider(),
        ),
        ChangeNotifierProvider.value(
          value: SocialProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UserTaskProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FinishedProvider(),
        ),
      ],
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Color(0xFFEEEFF5),
          accentColor: Color.fromARGB(255, 4, 157, 204),
          accentColorBrightness: Brightness.dark,
          buttonColor: Color.fromARGB(255, 4, 157, 204),
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Color(0xFF009570),
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return TabsScreen();
              }
              return AuthScreen();
            }),
      ),
    );
  }
}
