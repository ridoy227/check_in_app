import 'dart:ui';

import 'package:check_in/core/constants/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: const Color.fromARGB(255, 106, 77, 83),
      textColor: AppColors.white,
    );
  }
  static void showSuccessToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
    );
  }
}
