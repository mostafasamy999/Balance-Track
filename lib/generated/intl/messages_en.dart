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

  static String m0(amount) => "${amount} EGP";

  static String m1(name) => "Welcome, ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "add_new_client": MessageLookupByLibrary.simpleMessage("Add New Client"),
    "add_transaction": MessageLookupByLibrary.simpleMessage("Add Transaction"),
    "amount_label": MessageLookupByLibrary.simpleMessage("Amount"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "category_label": MessageLookupByLibrary.simpleMessage("Category"),
    "client_name": MessageLookupByLibrary.simpleMessage("Client Name"),
    "client_name_label": MessageLookupByLibrary.simpleMessage("Client Name"),
    "clients": MessageLookupByLibrary.simpleMessage("Clients"),
    "currency_egp": m0,
    "edit_transaction": MessageLookupByLibrary.simpleMessage(
      "Edit Transaction",
    ),
    "final_total": MessageLookupByLibrary.simpleMessage("Final Total"),
    "grand_total_label": MessageLookupByLibrary.simpleMessage("Grand Total"),
    "hello": MessageLookupByLibrary.simpleMessage("Hello"),
    "no_clients_found": MessageLookupByLibrary.simpleMessage(
      "No clients found",
    ),
    "no_data": MessageLookupByLibrary.simpleMessage("No data"),
    "no_transactions_found": MessageLookupByLibrary.simpleMessage(
      "No Transactions Found",
    ),
    "status_credit": MessageLookupByLibrary.simpleMessage("Credit"),
    "status_debt": MessageLookupByLibrary.simpleMessage("Debt"),
    "status_label": MessageLookupByLibrary.simpleMessage("Status:"),
    "status_negative": MessageLookupByLibrary.simpleMessage("Debt"),
    "status_positive": MessageLookupByLibrary.simpleMessage("Credit"),
    "status_pull": MessageLookupByLibrary.simpleMessage("Pull (-)"),
    "status_put": MessageLookupByLibrary.simpleMessage("Put (+)"),
    "total_pull": MessageLookupByLibrary.simpleMessage("Total Pull (-)"),
    "total_put": MessageLookupByLibrary.simpleMessage("Total Put (+)"),
    "transactions_appbar": MessageLookupByLibrary.simpleMessage("Transactions"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "welcome": m1,
  };
}
