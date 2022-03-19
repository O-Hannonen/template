// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(progress) => "Loading - ${progress}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "doYouHaveAccount": MessageLookupByLibrary.simpleMessage(
            "Do you have an account? Click here to sign in!"),
        "dontYouHaveAccount": MessageLookupByLibrary.simpleMessage(
            "Don\'t have an account? Click here to create one!"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailAddressTaken":
            MessageLookupByLibrary.simpleMessage("Email address taken"),
        "emailUpdateFailed":
            MessageLookupByLibrary.simpleMessage("Email update failed"),
        "grantPermissions":
            MessageLookupByLibrary.simpleMessage("Grant permissions"),
        "insufficientPermissions":
            MessageLookupByLibrary.simpleMessage("Insufficient permissions"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage("Invalid email"),
        "invalidPassword":
            MessageLookupByLibrary.simpleMessage("Invalid password"),
        "loadingProgress": m0,
        "logInAgainToProceed": MessageLookupByLibrary.simpleMessage(
            "Please log out and back in to proceed."),
        "openSettings": MessageLookupByLibrary.simpleMessage("Open settings"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordMismatch":
            MessageLookupByLibrary.simpleMessage("Password mismatch"),
        "passwordResetFailed":
            MessageLookupByLibrary.simpleMessage("Password reset failed"),
        "recentLoginRequired":
            MessageLookupByLibrary.simpleMessage("Recent login required"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
        "signingInFailed":
            MessageLookupByLibrary.simpleMessage("Signing in failed"),
        "signingUpFailed":
            MessageLookupByLibrary.simpleMessage("Signing up failed"),
        "theFollowingPermissionsAreDenied":
            MessageLookupByLibrary.simpleMessage(
                "The following permissions are denied"),
        "theFollowingPermissionsArePermanentlyDenied":
            MessageLookupByLibrary.simpleMessage(
                "The following permissions are permanently denied. You need to grant them in your phones settings."),
        "unknownErrorOccured":
            MessageLookupByLibrary.simpleMessage("Unknown error occurred"),
        "userDisabled": MessageLookupByLibrary.simpleMessage("User disabled"),
        "userNotFound": MessageLookupByLibrary.simpleMessage("User not found"),
        "weakPassword": MessageLookupByLibrary.simpleMessage("Weak password")
      };
}
