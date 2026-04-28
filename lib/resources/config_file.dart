
class ConfigFile {
  static const String apiBaseURL = "";

  ///************************ Logger Config  Key and values ***************************///
  static const bool showBlocTransitions = true;

  ///************************** Api and other Error codes *********************************///

  static const int noInternetErrorCode = 110;
  static const int unExpectedErrorCode = 101;

  ///************************** Application API URLs ************************************///

  ///-->Authentication API URL
  ///
  static String country = "${apiBaseURL}country";
}
