class CustomFieldBlocValidators {
  CustomFieldBlocValidators._();

  static String https(String string) {
    final httpsRegExp = RegExp(r'^https://', caseSensitive: false);

    if (string == null || string.isEmpty || httpsRegExp.hasMatch(string)) {
      return null;
    }

    return "Must start with \"https://\"";
  }

  static String absolutePath(String string) {
    final httpsRegExp = RegExp(r'^[a-zA-Z]:[/\\]');

    if (string == null || string.isEmpty || httpsRegExp.hasMatch(string)) {
      return null;
    }

    return "Must start with drive letter, like \"d:/data\"";
  }

  static String integer(String string) {
    final httpsRegExp = RegExp(r'^\d+$');

    if (string == null || string.isEmpty || httpsRegExp.hasMatch(string)) {
      return null;
    }

    return "Must be an integer";
  }

  static String passwordMin8Chars(String string) {
    if (string == null || string.isEmpty || string.runes.length >= 8) {
      return null;
    }
    return "Must be 8 characters or more";
  }
}