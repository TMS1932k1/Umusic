import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:umusic/constants/app_constant.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/screens/auth_screen.dart';
import 'package:umusic/widgets/icon_user.dart';

class HomeScreen extends StatefulWidget {
  static const nameRoute = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Change current page
  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Go to auth screen
  // With params:
  //   -- [BuildContext context] to provide to Theme.of() and Navigator.of()
  void _goToAuthScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AuthScreen.nameRoute);
  }

  // Show dialog to confirm sign out
  // With params:
  //   -- [BuildContext context] to provide to Theme.of() and Navigator.of()
  Future<void> showDialogSignOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'Sign Out',
            style: titleSmall,
          ),
          content: const Text(
            'Do you want to sign out this account?',
            style: textMedium,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Disable',
                style: textSmall,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Enable',
                style: titleSmall,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                signOut();
              },
            ),
          ],
        );
      },
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(pages[_currentIndex]['name']),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: gradientBackgroud,
        ),
        child: pages[_currentIndex]['page'],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        onClick: _updateCurrentIndex,
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar({
    Function(int)? onClick,
  }) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onClick,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: colorWhite,
      unselectedItemColor: colorGray,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: pages
          .map(
            (page) => BottomNavigationBarItem(
              label: page['name'],
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: FaIcon(
                  page['icon'],
                  size: kSizeIconSmall,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      toolbarHeight: kHeightAppBar,
      title: Padding(
        padding: const EdgeInsets.only(
          top: kPandingLarge,
        ),
        child: Text(
          title,
          style: titleExtra,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            top: kPandingExtra,
            right: kPandingMedium,
          ),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconUser(
                  snapshot.data!.email!.substring(0, 1).toUpperCase(),
                  onClick: () => showDialogSignOut(context),
                );
              } else {
                return IconButton(
                  onPressed: () => _goToAuthScreen(context),
                  icon: const FaIcon(FontAwesomeIcons.circleUser),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
