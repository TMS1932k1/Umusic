import 'package:flutter/material.dart';
import 'package:umusic/constants/app_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/widgets/form_input.dart';

class AuthScreen extends StatelessWidget {
  static const nameRoute = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: kToolbarHeight + kPandingMedium,
          right: kPandingSmall,
          left: kPandingSmall,
          bottom: kPandingSmall,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageWelcome),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: const Center(
          child: FormInput(),
        ),
      ),
    );
  }
}
