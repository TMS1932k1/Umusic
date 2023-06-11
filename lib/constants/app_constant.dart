import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:umusic/screens/bookmark_screen.dart';
import 'package:umusic/screens/discover_screen.dart';
import 'package:umusic/screens/on_device_screen.dart';
import 'package:umusic/screens/search_screen.dart';

List<Map<String, dynamic>> pages = [
  {
    'name': 'Discover',
    'page': const DiscoverScreen(),
    'icon': FontAwesomeIcons.house,
  },
  {
    'name': 'Search',
    'page': const SearchScreen(),
    'icon': FontAwesomeIcons.magnifyingGlass,
  },
  {
    'name': 'Bookmark',
    'page': const BookmartScreen(),
    'icon': FontAwesomeIcons.bookmark,
  },
  {
    'name': 'On Device',
    'page': const OnDeviceScreen(),
    'icon': FontAwesomeIcons.mobile,
  },
];

const imageSongPlaceholder = 'assets/images/placeholder_music.png';
const imageArtistPlaceholder = 'assets/images/placeholder_person.png';
const imageWelcome = 'assets/images/wellcome.jpg';
const imageLogo = 'assets/images/logo.png';
