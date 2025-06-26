class AppHelper {
  AppHelper._();

  static String formatDate(String inputDate) {
    try {
      final parsedDate = DateTime.parse(inputDate);

      return '${parsedDate.day.toString().padLeft(2, '0')} '
          '${_monthAbbreviation(parsedDate.month)} '
          '${parsedDate.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static String _monthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
