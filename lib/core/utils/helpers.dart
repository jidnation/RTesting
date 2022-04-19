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

  static String parseChatDate(String date){
    final dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if(diff.inDays > 0){
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }else if(diff.inHours > 0){
      return '${diff.inHours}h';
    }else if(diff.inMinutes > 0){
      return '${diff.inMinutes}m';
    }else{
      return '${diff.inSeconds}s';
    }
  }
}
