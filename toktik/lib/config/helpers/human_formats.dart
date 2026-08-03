import 'package:intl/intl.dart';

class HumanFormats {

  static String humanReadableNumber( double number, [int decimals = 0] ) {
    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
    ).format(number);
    
    return formatterNumber;
  }
}