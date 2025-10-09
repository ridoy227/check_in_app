import 'package:check_in/core/services/firebase_service.dart';
import 'package:check_in/firebase_options.dart';
import 'package:check_in/presentation/providers/home_provider.dart';
import 'package:check_in/presentation/screens/create_checkin_screen.dart';
import 'package:check_in/presentation/screens/home_screen.dart';
import 'package:check_in/presentation/screens/sign_in_screen.dart';
import 'package:check_in/presentation/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_texts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CheckInApp());
}

class CheckInApp extends StatelessWidget {
  const CheckInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirebaseService().firebaseAuth.currentUser != null? const HomeScreen() : SignUpScreen(),
        routes: {
          '/create-checkin': (context) => const CreateCheckinScreen(),
          '/home': (context) => const HomeScreen(),
          '/singIn': (context) =>  SignInScreen(),
          '/signUp': (context) =>  SignUpScreen(),
        },
      ),
    );
  }
}
