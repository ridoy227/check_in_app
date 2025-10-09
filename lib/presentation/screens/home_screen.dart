import 'package:check_in/core/constants/app_texts.dart';
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
      ),
      body:  Stack(
        children: [
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return MapWidget(
                showCircles: provider.showHomeRadius,
                showMarkers: provider.showHomeRadius,
              );
            }
          ),
          Positioned(
            top: 20,
            left: 20,
            child: InformationCardWidget(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomIconButton(
        text: "Create Check In Point",
        onTap: () {
          Navigator.pushNamed(context, '/create-checkin');
        },
      ),
    );
  }
}
