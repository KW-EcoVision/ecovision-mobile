class NameValidator {
  bool? isValid;

  bool validate(String name) {
    final regex = RegExp(r'^[a-zA-Z가-힣]+$');

    return name.isNotEmpty && regex.hasMatch(name);
  }
}
