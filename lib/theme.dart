// This file is part of Bayad Matthew.

// Bayad Matthew is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// any later version.

// Bayad Matthew is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Bayad Matthew.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData bayadDarkTheme(BuildContext context) {
  return ThemeData(
    //Theme for texts in the application
    textTheme: const TextTheme().copyWith(
      //Used for Bold Title Texts
      headline1: GoogleFonts.roboto(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Colors.grey[350],
      ),
      //Used for normal texts
      headline2: GoogleFonts.roboto(
        fontSize: 30,
        color: Colors.grey[350],
      ),
      headline3: GoogleFonts.roboto(
        fontSize: 25,
        color: Colors.grey[350],
      ),
      headline4: GoogleFonts.roboto(
        fontSize: 20,
        color: Colors.grey[350],
      ),
      //Used for button texts
      button: GoogleFonts.roboto(
        fontSize: 14,
        color: Colors.black,
      ),
      //Used for small texts
      subtitle1: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.grey[350],
      ),
    ),
    //Icon Theme in the application
    iconTheme: IconThemeData(color: Colors.green[200]),

    //Theme for the App Bar
    appBarTheme: const AppBarTheme(
      color: Color.fromRGBO(23, 23, 23, 1),
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.blueGrey, fontSize: 25),
    ),

    //The background color that will be shown in every screen
    canvasColor: const Color.fromRGBO(23, 23, 23, 1),
    //Defines the brightness of the application
    //brightness: Brightness.dark,
    //The colors and their properties that are used in our app
    colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Colors.blue,
          secondary: Colors.green,
        ),
    //Theme for Divider
    dividerColor: Colors.white,
    //The theme for the buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
        alignment: Alignment.center,
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 199, 199, 199),
        ),
        elevation: MaterialStateProperty.all<double>(10),
        enableFeedback: true, //Vibration or Haptic Feedback on Android or iOS
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ),
    buttonTheme: ButtonTheme.of(context).copyWith(
      hoverColor: Colors.grey,
      highlightColor: Colors.grey,
      buttonColor: Colors.white,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
