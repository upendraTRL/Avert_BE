import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/fitness_app/home_1.png',
      selectedImagePath: 'assets/fitness_app/home_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/preventions_1.png',
      selectedImagePath: 'assets/fitness_app/preventions_1s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/settings_1.png',
      selectedImagePath: 'assets/fitness_app/settings_1s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/profile_1.png',
      selectedImagePath: 'assets/fitness_app/profile_1s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
