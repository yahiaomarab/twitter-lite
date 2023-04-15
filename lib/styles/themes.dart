import 'package:flutter/material.dart';
import 'package:twitter_lite/shared/colors.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Myfont',
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: buttonsColor),
  scaffoldBackgroundColor: Colors.black87,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: buttonsColor),
    titleTextStyle: TextStyle(
        fontFamily: 'Myfont',
        color: Colors.white,
        fontSize: 35,
        fontWeight: FontWeight.bold),
    backgroundColor: Colors.black87,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: buttonsColor,
      elevation: 20,
      backgroundColor: Colors.black),
  primaryColor: Colors.white,
  textTheme: const TextTheme(
    caption: TextStyle(
        fontSize: 14,
        fontFamily: 'Myfont',
        color: Colors.white),
    subtitle1: TextStyle(
      fontSize: 20,
      fontFamily: 'Myfont',
    ),
    bodyText1: TextStyle(
        fontSize: 20,
        fontFamily: 'Myfont',
        fontWeight: FontWeight.bold,
        color: Colors.white),
    bodyText2: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    subtitle2: TextStyle(
        fontSize: 20,
        fontFamily: 'Myfont',
        fontWeight: FontWeight.bold,
        color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: Colors.white,
    suffixIconColor: Colors.white,
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
    hintStyle: const TextStyle(
      color: Colors.white,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black87),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black87, width: 2),
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);
ThemeData lightTheme = ThemeData(
    fontFamily: 'Myfont',
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: buttonsColor),
    scaffoldBackgroundColor: backGround,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: buttonsColor),
      titleTextStyle: TextStyle(
          fontFamily: 'Myfont',
          color: textColor,
          fontSize: 25,
          fontWeight: FontWeight.bold),
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: buttonsColor,
        elevation: 20),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
          fontSize: 17,
          height: 1.3,
          fontWeight: FontWeight.w800,
          color: Colors.black87),
      subtitle2: TextStyle(
          fontSize: 20,
          fontFamily: 'Myfont',
          fontWeight: FontWeight.bold,
          color: Colors.black),
      caption: TextStyle(
          fontSize: 14,
          fontFamily: 'Myfont',
          color: Colors.grey),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: buttonsColor,
      suffixIconColor: buttonsColor,
      focusColor: buttonsColor,
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: buttonsColor)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    ));
