// ignore_for_file: use_build_context_synchronously

import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:check_in/core/services/firebase_service.dart';
import 'package:check_in/presentation/widgets/custom_create_button.dart';
import 'package:check_in/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Sign In",
              style: TextFontStyle.smallMedium
                  .copyWith(fontSize: 24, color: AppColors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              controller: passwordController,
              hintText: "Password",
            ),
            const SizedBox(
              height: 16,
            ),
            CustomIconButton(
                onTap: () {
                  FirebaseService()
                      .signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim())
                      .then((value) {
                    if (value) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (Route<dynamic> route) => false,
                      );
                    }
                  });
                },
                icon: const Icon(
                  Icons.login,
                  color: AppColors.white,
                ),
                text: "Sign In"),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signUp");
                },
                child: const Text("Don't have account? Sign Up"))
          ],
        ),
      ),
    );
  }
}
