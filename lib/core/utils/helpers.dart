class Helper {
  static String parseDate(DateTime? date) {
    String? day = '', month = '';
    final year = date!.year.toString();
    if (date.month.toString().length < 2) {
      month = '0${date.month.toString()}';
    } else {
      month = date.month.toString();
    }

    if (date.day.toString().length < 2) {
      day = '0${date.day.toString()}';
    } else {
      day = date.day.toString();
    }

    return '$day-$month-$year';
  }
}
