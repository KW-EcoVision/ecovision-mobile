class PasswordValidator {
  bool? isValid;

  bool validate(String password) {
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final lengthValid = password.length >= 9;

    return hasDigit && hasLetter && lengthValid;
  }
}
