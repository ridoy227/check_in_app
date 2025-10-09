import 'dart:developer';

import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:check_in/core/services/firestore_service.dart';
import 'package:check_in/presentation/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformationCardWidget extends StatelessWidget {
  const InformationCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: FirestoreService().activeUsersStream(),
              builder: (context, asyncSnapshot) {
                return Text(
                  'Total Check-Ins: ${asyncSnapshot.data?.length}',
                  style: TextFontStyle.smallMedium
                      .copyWith(color: AppColors.black),
                );
              }),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: FirestoreService().userCheckInStatusStream(),
            builder: (context, asyncSnapshot) {
              log("checking ==== ${asyncSnapshot.data}");
              if(asyncSnapshot.data == null){
                return const SizedBox.shrink();
              }
              return Text(
                'Check-In Status: ${asyncSnapshot.data! ? "Active" : "Inactive"}',
                style: TextFontStyle.smallMedium.copyWith(color: AppColors.black),
              );
            }
          ),
        ],
      ),
    );
  }
}
