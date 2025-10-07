import 'package:check_in/core/constants/app_colors.dart';
import 'package:check_in/core/constants/text_styles.dart';
import 'package:check_in/presentation/providers/home_provider.dart';
import 'package:check_in/presentation/widgets/custom_create_button.dart';
import 'package:check_in/presentation/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCheckinScreen extends StatelessWidget {
  const CreateCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Check-In',
          style: TextFontStyle.smallMedium
              .copyWith(color: AppColors.black, fontSize: 22),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextFontStyle.smallMedium
                    .copyWith(color: AppColors.primary, fontSize: 18),
              ))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapWidget(
                  showCircles: true,
                  showMarkers: true,
                  onSelectLocation: (location) {
                    context.read<HomeProvider>().addCheckInPoint(location);
                  },
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Note: You can also select a location on the map by tapping on it',
            style: TextFontStyle.smallMedium
                .copyWith(fontSize: 12, color: AppColors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomIconButton(
              icon: const Icon(Icons.my_location, color: Colors.white),
              text: "Use Current Location",
              height: 60,
              onTap: () => context.read<HomeProvider>().addCheckInPoint(
                  context.read<HomeProvider>().currentLocation!)),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Adjust Location Radius ( meters )',
            style: TextFontStyle.smallMedium
                .copyWith(fontSize: 12, color: AppColors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return Slider(
                value: provider.locationRadius,
                min: 0,
                max: 500,
                divisions: 20,
                onChanged: (values) {
                  provider.updateRadius(values);
                },
                label:
                    'Radius: ${provider.locationRadius.toStringAsFixed(0)} m',
              );
            },
          ),
        ],
      ),
    );
  }
}
