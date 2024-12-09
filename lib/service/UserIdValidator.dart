class UserIdValidator {
  bool? isValid;

  bool validate(String userId) {
    final hasDigit = RegExp(r'\d').hasMatch(userId);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(userId);
    final lengthValid = userId.length >= 5 && userId.length <= 20;

    return (hasDigit || hasLetter) && lengthValid;
  }
}
