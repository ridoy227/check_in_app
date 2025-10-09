import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/app_texts.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:check_in/presentation/providers/home_provider.dart';
import 'package:check_in/presentation/widgets/custom_create_button.dart';
import 'package:check_in/presentation/widgets/information_card_widget.dart';
import 'package:check_in/presentation/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).fetchCheckInPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appName),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-checkin');
              },
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: AppColors.white,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Create Point", style: TextFontStyle.smallMedium)
                  ],
                ),
              )),
        ],
      ),
      body: Stack(
        children: [
          Consumer<HomeProvider>(builder: (context, provider, child) {
            return MapWidget(
              showCircles: provider.showHomeRadius,
              showMarkers: provider.showHomeRadius,
            );
          }),
          const Positioned(
            top: 20,
            left: 20,
            child: InformationCardWidget(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<HomeProvider>(builder: (context, provider, child) {
          return provider.showCheckinButton? CustomIconButton(
            icon: const Icon(Icons.check, color: AppColors.white,),
            text: provider.showCheckinButton? "Check In" : "Check Out",
            onTap: () {
              
            },
          ): Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.errorRed.withAlpha((1 * 255).round())
            ),
            child:  const Text(
              "You are not in the check-in radius",
              style: TextFontStyle.smallMedium,
            ),
          );
          
          // CustomIconButton(
          //   width: 250,
          //   icon: const Icon(Icons.location_searching, color: AppColors.white,),
          //   text: "Focus on my Current Location",
          //   onTap: () {
              
          //   },
          // );
        }
      ),
    );
  }
}
