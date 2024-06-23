// lib/date_utils.dart

import 'package:intl/intl.dart';

String formatDate(String date) {
  var originalFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  var targetFormat = DateFormat("dd/MM/yyyy");
  var originalDate = originalFormat.parse(date);
  var formattedDate = targetFormat.format(originalDate);

  return formattedDate;
}