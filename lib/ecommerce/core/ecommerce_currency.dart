import 'package:intl/intl.dart';

/// DummyJSON returns prices in USD. We show INR using a fixed FX rate for demo.
/// Replace with a live API or backend rate for production.
class EcommerceCurrency {
  EcommerceCurrency._();

  static const double usdToInr = 83.0;

  static double usdToInrAmount(double usd) => usd * usdToInr;

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Format a USD amount from the API as Indian Rupees for display.
  static String formatFromUsd(double usd) => _inr.format(usdToInrAmount(usd));
}
