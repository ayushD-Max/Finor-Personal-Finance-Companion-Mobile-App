import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0, // INR often used without decimals for simple apps
  );

  static String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}
