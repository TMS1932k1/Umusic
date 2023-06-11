import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusic/providers/artist_provider.dart';
import 'package:umusic/providers/bookmark_provider.dart';
import 'package:umusic/providers/discover_provider.dart';
import 'package:umusic/providers/device_provider.dart';
import 'package:umusic/providers/play_song_bookmark_provider.dart';
import 'package:umusic/providers/play_song_provider.dart';
import 'package:umusic/providers/playlist_provider.dart';
import 'package:umusic/providers/process_download_provider.dart';
import 'package:umusic/providers/search_provider.dart';
import 'package:umusic/screens/artist_screen.dart';
import 'package:umusic/screens/auth_screen.dart';
import 'package:umusic/screens/home_screen.dart';
import 'package:umusic/screens/play_song_screen.dart';
import 'package:umusic/screens/playlist_screen.dart';
import 'package:umusic/screens/splash_screen.dart';
import 'package:umusic/themes/theme.dart';

bool? isFirst;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init firebase on app
  await Firebase.initializeApp();

  // Get [bool isFirst] in SF, check this is first run app
  final prefs = await SharedPreferences.getInstance();
  isFirst = prefs.getBool('isFirst');
  await prefs.setBool('isFirst', true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DiscoverProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ArtistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaySongProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookmarkProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProcessDownloadProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeviceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaySongBookMarkProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        // If this is first run app
        initialRoute: (isFirst == null || !isFirst!)
            ? SplashScreen.nameRoute // will go to splash screen
            : HomeScreen.nameRoute, // else go to home screen
        routes: {
          HomeScreen.nameRoute: (context) => const HomeScreen(),
          SplashScreen.nameRoute: (context) => const SplashScreen(),
          PlaylistScreen.nameRoute: (context) => const PlaylistScreen(),
          ArtistScreen.nameRoute: (context) => const ArtistScreen(),
          PlaySongScreen.nameRoute: (context) => const PlaySongScreen(),
          AuthScreen.nameRoute: (context) => const AuthScreen(),
        },
      ),
    );
  }
}
