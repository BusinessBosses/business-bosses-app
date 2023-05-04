import 'package:flutter/cupertino.dart';

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
  static String emailValidator(String? val) {
    debugPrint('Validator.emailValidator: $val');
    if (val == null) return 'Email cannot be empty';
    if (!isValidEmail(val)) {
      return 'Invalid email';
    } else {
      return '';
    }
  }

  /// Validate password fields to be password
  static String passwordValidator(String? val) {
    if (val == null) {
      return 'Enter a valid password';
    }
    if (val.length < 8) {
      return 'Password must be 8 character long';
    }
    if (!isValidPassword(val)) {
      return 'Invalid p';
    } else {
      return '';
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
  static String? usernameValidator(String val) {
    if (val == "") return 'Username cannot be empty';
    if (val.length <= 3) return 'Username is too short';
    if (val.contains(' ')) return 'You can\'t enter space';
    // if (isUnique) return 'Enter a unique username';
    // if (!isUnique) if (val.length < 2) return 'username is too short';
    // if (!isUnique) return 'User name already exist';

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
  static String? nameValidator(String val) {
    if ((val.trim().isEmpty)) {
      return 'Name cannot be empty';
    }
    if (val.length < 2) return 'Name is too short';
    return null;
  }

  /// VAlidate bio is not empty
  static String? bioValidator(String val) {
    if ((val.trim().isEmpty)) {
      return 'Bio cannot be empty';
    }
    if (val.length < 12) return 'Bio is too short';
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
