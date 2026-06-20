class NumberFormatter {
  static String formatNumber(int number) {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.toString().replaceAllMapped(
      reg,
      (Match match) => '${match[1]},',
    );
  }
}
