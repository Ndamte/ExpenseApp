import 'dart:math';

import 'package:flutter/material.dart';

// DataMap needs to be imported from the page where the user enters expenses, this is for temporay purposes
Map<String, double> dataMap = {
  "Category 1": 30.0,
  "Category 2": 20.0,
  "Category 3": 40.0,
  "Category 4": 10.0,
  "Category 5": 35.0,
};

List<Color> generateRandomColors(int numberOfColors) {
  List<Color> colors = [];
  Random random = Random();

  for (int i = 0; i < numberOfColors; i++) {
    // Generate a random vibrant color
    Color color = Color.fromARGB(
      255,
      random.nextInt(256), // Red component
      random.nextInt(256), // Green component
      random.nextInt(256), // Blue component
    );
    colors.add(color);
  }

  return colors;
}
