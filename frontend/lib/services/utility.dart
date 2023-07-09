class Utility {
  static String getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');

    List<String> initials = nameParts.map((name) {
      if (name.isNotEmpty) {
        return name[0].toUpperCase();
      }
      return '';
    }).toList();

    return initials.join('');
  }
}