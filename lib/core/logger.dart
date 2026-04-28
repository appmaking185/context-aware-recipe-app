import 'package:logger/logger.dart';

final logger = Logger(
  filter: MyFilter(),
  printer: PrefixPrinter(PrettyPrinter()),
);

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
