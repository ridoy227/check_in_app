import 'package:check_in/core/constants/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: AppColors.errorRed,
      textColor: AppColors.white,
    );
  }
}
