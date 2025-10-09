import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/services/firebase_service.dart';
import 'package:check_in/presentation/widgets/custom_create_button.dart';
import 'package:flutter/material.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 320,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16))),
        child: Column(
          children: [
            const Spacer(),
            CustomIconButton(
                onTap: () {
                  FirebaseService().logout().then((value) {
                    if (value) {
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/singIn',
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  });
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.white,
                ),
                text: "Logout"),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
