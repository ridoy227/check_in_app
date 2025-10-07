import 'package:check_in/presentation/providers/home_provider.dart';
import 'package:check_in/presentation/screens/create_checkin_screen.dart';
import 'package:check_in/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_texts.dart';

void main() {
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
        home: const HomeScreen(),
        routes: {
          '/create-checkin': (context) => const CreateCheckinScreen(),
        },
      ),
    );
  }
}
