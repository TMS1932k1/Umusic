import 'package:flutter/material.dart';
import 'package:umusic/constants/app_constant.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  static const nameRoute = '/splash';
  const SplashScreen({super.key});

  void _gotoHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.nameRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(kPandingSmall),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageWelcome),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageLogo, height: kSizeLogo, width: kSizeLogo),
            const SizedBox(height: kPandingMedium),
            Text(
              'U MUSIC',
              style: titleExtra.copyWith(color: colorWhite),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kPandingSmall),
            SizedBox(
              width: 320,
              child: Text(
                'Starting pack for beginners. Containing all necessary assets, typography and color systems for quicker and more efficient learning.',
                style: textMedium.copyWith(color: colorWhite),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: kPandingLarge),
            ElevatedButton(
              onPressed: () => _gotoHomeScreen(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPandingLarge * 2,
                  vertical: kPandingMedium,
                ),
                child: Text(
                  'Watch Tutorial',
                  style: titleSmall.copyWith(color: colorWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
