import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/app_texts.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:check_in/core/services/firebase_service.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        title: const Text(appName),
        centerTitle: !context.read<HomeProvider>().checkIfAdmin(),
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        actions: [
          if (context.read<HomeProvider>().checkIfAdmin())
            CustomIconButton(
              width: 120,
              onTap: () {
                Navigator.pushNamed(context, '/create-checkin');
              },
              text: "Create Point",
            ),
          const SizedBox(
            width: 4,
          )
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
      floatingActionButton:
          Consumer<HomeProvider>(builder: (context, provider, child) {
        return provider.showCheckinButton
            ? CustomIconButton(
                icon: const Icon(
                  Icons.check,
                  color: AppColors.white,
                ),
                text: provider.showCheckinButton ? "Check In" : "Check Out",
                onTap: () {
                  provider.checInOut();
                },
              )
            : Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.errorRed.withAlpha((1 * 255).round())),
                child: const Text(
                  "You are not in the check-in radius",
                  style: TextFontStyle.smallMedium,
                ),
              );
      }),
    );
  }
}

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
            Spacer(),
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
