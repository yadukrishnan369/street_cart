class ProfileHelper {
  // Get Name Initials
  static String getInitials(String name) {
    if (name.trim().isEmpty) return 'AD';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      final first = parts[0];
      final second = parts[1];
      if (first.isNotEmpty && second.isNotEmpty) {
        return (first[0] + second[0]).toUpperCase();
      }
    }
    if (name.trim().length > 1) {
      return name.trim().substring(0, 2).toUpperCase();
    }
    return name.trim().toUpperCase();
  }
}
