import 'package:flutter/material.dart';
import 'package:instagram_app/screens/add_post_screen.dart';
import 'package:instagram_app/screens/feed_screen.dart';
import 'package:instagram_app/screens/search_screen.dart';

const webScreenSize=600;

const homeScreenList = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Favourite'),
  Text('About'),
];
