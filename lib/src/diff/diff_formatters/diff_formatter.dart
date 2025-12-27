import '../diff_result.dart';

abstract class DiffFormatter {
  String format(DiffResult result);
}
