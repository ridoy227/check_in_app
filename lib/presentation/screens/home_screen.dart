import 'package:check_in/core/constants/app_texts.dart';
import 'package:check_in/presentation/widgets/custom_create_button.dart';
import 'package:check_in/presentation/widgets/information_card_widget.dart';
import 'package:check_in/presentation/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appName),
      ),
      body: const Stack(
        children: [
          MapWidget(),
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
