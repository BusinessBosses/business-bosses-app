import 'package:get/get.dart';

/// Validate Form Fields
class Validator {
  /// Validate Email
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /// Validate Passwords To be Passwords
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    if (password.contains(' ')) return false;
    return password.length >= 8 ? true : false;
  }

  /// Validate FIelds TO Be not Empty
  static bool isValidField(String text) {
    if (text.isEmpty) return false;
    return text.trim().length >= 2 ? true : false;
  }

  /// VAlidate Field to be email
  static String? emailValidator(String? val) {
    if (val == null) return 'Email cannot be empty';
    if (!val.isEmail) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  /// VAlidate Field to be email and does not exist
  static String? emailValidatorSignUp(String? val, {required bool isUnique}) {
    if (val == null) return 'Email cannot be empty';
    if (isUnique == false) return 'Enter a unique email';
    if (!isValidEmail(val)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  /// Check if it exists from api
  static bool? emailValidatorExists(String? val, {required bool isUnique}) {
    if (!isValidEmail(val!)) {
      return false;
    } else {
      return true;
    }
  }

  /// Validate password fields to be password
  static String? passwordValidator(String? val) {
    if (val == null) {
      return 'Enter a valid password';
    }
    if (val.length < 8) {
      return 'Password must be 8 character long';
    }
    if (!isValidPassword(val)) {
      return 'Invalid password';
    } else {
      return null;
    }
  }

  /// Validate phone number
  static String phoneValidator(String? val) {
    if (val == null) {
      return 'Enter a valid phone number';
    }

    if (!isValidField(val)) {
      return 'Invalid phone';
    } else {
      return '';
    }
  }

  /// Validate if username
  static String? usernameValidator(String val, {required bool isUnique}) {
    if (val == '') return 'Username cannot be empty';
    if (val.length < 3) return 'Username is too short';
    if (val.contains(' ')) return 'You can\'t enter space';
    if (isUnique == false) return 'Enter a unique username';
    if (!isUnique) if (val.length < 2) return 'username is too short';
    if (!isUnique) return 'User name already exist';

    return null;
  }

  /// Validate Social media accounts
  static String? socialValidator(
    String val,
    String type,
  ) {
    if (val.length <= 3) return '$type is too short';
    if (val.contains(' ')) return 'You can\'t enter space';
    return null;
  }

  /// Validate if username is correct
  static bool? isUniqueUsername(String val, List<String> allUsernames) {
    if (val.isEmpty) return null;
    if (val.length <= 3) return null;
    if (val.contains(' ')) return null;
    if (allUsernames.isEmpty) {
      return null;
    } else {
      return !allUsernames.contains(val.toLowerCase());
    }
  }

  /// VAlidate if password is correct as first password
  static String? confirmPasswordValidator(String val1, String val2) {
    if (!isValidPassword(val1)) return 'Invalid password';
    if (val1 != val2) return 'Password don\'t match';
    return null;
  }

  /// Validate if name is valid
  static String? nameValidator(String? val) {
    if ((val?.trim().isEmpty ?? true)) {
      return 'Name cannot be empty';
    }
    if (val!.length < 2) return 'Name is too short';
    return null;
  }

  /// VAlidate bio is not empty
  static String? bioValidator(String? val) {
    if (val == null) {
      return 'Bio cannot be null';
    }
    val = val.trim();
    if (val.isEmpty) {
      return 'Bio cannot be empty';
    }
    if (val.length < 12) {
      return 'Bio is too short';
    }
    if (RegExp(r'[^\x20-\x7E]').hasMatch(val)) {
      return 'Bio contains invalid characters';
    }

    return null;
  }

  /// Valid if entered is a url
  static String? websiteValidator(String val) {
    if ((val.trim().isEmpty)) {
      return 'Url cannot be empty';
    }
    if (val.contains(' ')) return 'Invalid Url';
    return null;
  }

  /// Validate social links
  static String? socialLinkValidator(String val) {
    if (val.contains(' ')) return 'You can\'t enter space';
    if (val.length < 2) return 'Invalid value';
    return null;
  }
}
