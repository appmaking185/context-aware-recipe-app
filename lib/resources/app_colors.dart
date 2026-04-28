import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//create custom Colors
MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};
  // ignore: avoid_multiple_declarations_per_line
  final int r = color.r.toInt(), g = color.g.toInt(), b = color.b.toInt();

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  // ignore: avoid_function_literals_in_foreach_calls

  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.toARGB32(), swatch);
}

class AppColors {
  static var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  // static const colorPrimaryDark = Color(0xFF00c0cc);

  // static const colorPrimaryLight = Color(0xFF6440FE);
  static const appColor = Color(0xFF28AAE0);

  // static const colorPrimaryBackGroundLight = Color(0xFFFFFFFF);
  static const colorPrimaryBackGround = Color(0xFF1C1C28);

  static const primaryBlackWhite = Colors.black;

  static const appBlueColor = Color(0xFFEAF7FC);
  static const appDarkBlueColor = Color(0xFF0C53A9);
  static const lightBlueColorC1E6F5 = Color(0xFFC1E6F5);
  static const textFieldHintColor = Color(0xFF8F90A6);

  static const white = Colors.white;
  static const black = Colors.black;
  static const grey = Colors.grey;
  static const red = Colors.red;
  static const yellow = Colors.yellow;
  static const green = Colors.green;

  static const alertcolor = Color(0xFFFC4949);
  static const greyBackground = Color(0xFFF5F5F5);
  static const greyBackgroundE4E9EB = Color(0xFFE4E9EB);

  static const borderColorE6E6E6 = Color(0xFFE6E6E6);
  static const borderColorEBEBF0 = Color(0xFFEBEBF0);
  static const textColor1C1C28 = Color(0xFF1C1C28);
  static const textColor525252 = Color(0xFF525252);
  static const textColor757575 = Color(0xFF757575);
  static const textColor78909B = Color(0xFF78909B);
  static const textRedColorE53535 = Color(0xFFE53535);
  static const disableColorF2F2F5 = Color(0xFFA0B1B9);
  static const dividerColorD1D4E0 = Color(0xFFD1D4E0);
  static const dividerColorC4C4C4 = Color(0xFFC4C4C4);

  static const greenColor05A660 = Color(0xFF05A660);
  static const greenColorE3FFF1 = Color(0xFFE3FFF1);

  static const messageErrorBgColor = Colors.red;

  static const custBlue49bdf5 = Color(0xFF49bdf5);
  static const custDarkBlue074FA9 = Color(0xFF074FA9);
  static const custGreen91d775 = Color(0xFF91d775);
  static const custGreen95db78 = Color(0xFF95db78);
  static const custGreena0e08b = Color(0xFFa0e08b);
  static const custLightBluecbe1e9 = Color(0xFFcbe1e9);
  static const custDarkBlue18386B = Color(0xFF18386B);
  static const custLightBlueB6E2EC = Color(0xFFB6E2EC);
  static const custDarkestBlue0445A0 = Color(0xFF0445A0);
  static const custBlue28AAE0 = Color(0xFF28AAE0);
  static const custGreen7ABA70 = Color(0xFF7ABA70);
  static const custGreen036746 = Color(0xFF036746);
  static const custBlue0C53A9 = Color(0xFF0C53A9);
  static const custGrayB3B3B3 = Color(0xFFB3B3B3);
  static const custBlueC1E6F5 = Color(0xFFC1E6F5);
  static const custDarkLightBlue008DD2 = Color(0xFF008DD2);
  static const custBlueEAF7FC = Color(0xFFEAF7FC);
  static const custGray757575 = Color(0xFF757575);
  static const  custBlack0A0909 = Color(0xFF0A0909);
  static const custYellow = Color.fromARGB(255, 215, 196, 26);
}
