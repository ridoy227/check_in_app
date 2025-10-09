// ignore_for_file: use_build_context_synchronously

import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:check_in/core/services/firebase_service.dart';
import 'package:check_in/presentation/widgets/custom_create_button.dart';
import 'package:check_in/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController nameController = TextEditingController();
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
              "Sign Up",
              style: TextFontStyle.smallMedium
                  .copyWith(fontSize: 24, color: AppColors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              controller: nameController,
              hintText: "Name",
            ),
            const SizedBox(
              height: 16,
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
                      .signUp(
                          name: nameController.text.trim(),
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
                text: "Sign Up"),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/singIn");
                },
                child: const Text("Already have account? Sign In"))
          ],
        ),
      ),
    );
  }
}
