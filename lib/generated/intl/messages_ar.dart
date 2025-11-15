// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(amount) => "${amount} جنيه";

  static String m1(name) => "مرحباً، ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add": MessageLookupByLibrary.simpleMessage("إضافة"),
    "add_new_client": MessageLookupByLibrary.simpleMessage("إضافة عميل جديد"),
    "add_transaction": MessageLookupByLibrary.simpleMessage("إضافة معاملة"),
    "amount_label": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "category": MessageLookupByLibrary.simpleMessage("الفئة"),
    "category_label": MessageLookupByLibrary.simpleMessage("الفئة"),
    "client_name": MessageLookupByLibrary.simpleMessage("اسم العميل"),
    "client_name_label": MessageLookupByLibrary.simpleMessage("اسم العميل"),
    "clients": MessageLookupByLibrary.simpleMessage("العملاء"),
    "currency_egp": m0,
    "edit_transaction": MessageLookupByLibrary.simpleMessage("تعديل معاملة"),
    "final_total": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "grand_total_label": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "hello": MessageLookupByLibrary.simpleMessage("مرحبا"),
    "no_clients_found": MessageLookupByLibrary.simpleMessage("لا يوجد عملاء"),
    "no_data": MessageLookupByLibrary.simpleMessage("لا توجد بيانات"),
    "no_transactions_found": MessageLookupByLibrary.simpleMessage(
      "لا توجد معاملات",
    ),
    "status_credit": MessageLookupByLibrary.simpleMessage("له"),
    "status_debt": MessageLookupByLibrary.simpleMessage("عليه"),
    "status_label": MessageLookupByLibrary.simpleMessage("الحالة:"),
    "status_negative": MessageLookupByLibrary.simpleMessage("عليه"),
    "status_positive": MessageLookupByLibrary.simpleMessage("له"),
    "status_pull": MessageLookupByLibrary.simpleMessage("سحب (-)"),
    "status_put": MessageLookupByLibrary.simpleMessage("إيداع (+)"),
    "total_pull": MessageLookupByLibrary.simpleMessage("إجمالي السحب (-)"),
    "total_put": MessageLookupByLibrary.simpleMessage("إجمالي الايداع (+)"),
    "transactions_appbar": MessageLookupByLibrary.simpleMessage("المعاملات"),
    "update": MessageLookupByLibrary.simpleMessage("تعديل"),
    "welcome": m1,
  };
}
