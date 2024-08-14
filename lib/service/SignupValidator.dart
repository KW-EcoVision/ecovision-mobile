class SignupValidator {
  bool? _isValidName;
  bool? _isValidUserId;
  bool? _isValidPassword;

  bool? get isValidName => _isValidName;
  set isValidName(bool? value) => _isValidName = value;

  bool? get isValidUserId => _isValidUserId;
  set isValidUserId(bool? value) => _isValidUserId = value;

  bool? get isValidPassword => _isValidPassword;
  set isValidPassword(bool? value) => _isValidPassword = value;

  bool validateName(String name) {
    final regex = RegExp(r'^[a-zA-Z가-힣]+$');

    return name.isNotEmpty && regex.hasMatch(name);
  }

  bool validateUserId(String userId) {
    final hasDigit = RegExp(r'\d').hasMatch(userId);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(userId);
    final lengthValid = userId.length >= 5 && userId.length <= 20;

    return hasDigit && hasLetter && lengthValid;
  }

  bool validatePassword(String password) {
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final lengthValid = password.length >= 9 && password.length <= 20;

    return hasDigit && hasLetter && lengthValid;
  }
}
