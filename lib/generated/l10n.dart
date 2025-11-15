// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Welcome, {name}!`
  String welcome(Object name) {
    return Intl.message(
      'Welcome, $name!',
      name: 'welcome',
      desc: '',
      args: [name],
    );
  }

  /// `Clients`
  String get clients {
    return Intl.message('Clients', name: 'clients', desc: '', args: []);
  }

  /// `No clients found`
  String get no_clients_found {
    return Intl.message(
      'No clients found',
      name: 'no_clients_found',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total`
  String get grand_total_label {
    return Intl.message(
      'Grand Total',
      name: 'grand_total_label',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get status_positive {
    return Intl.message('Credit', name: 'status_positive', desc: '', args: []);
  }

  /// `Debt`
  String get status_negative {
    return Intl.message('Debt', name: 'status_negative', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Client Name`
  String get client_name {
    return Intl.message('Client Name', name: 'client_name', desc: '', args: []);
  }

  /// `Add New Client`
  String get add_new_client {
    return Intl.message(
      'Add New Client',
      name: 'add_new_client',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get status_credit {
    return Intl.message('Credit', name: 'status_credit', desc: '', args: []);
  }

  /// `Debt`
  String get status_debt {
    return Intl.message('Debt', name: 'status_debt', desc: '', args: []);
  }

  /// `Put (+)`
  String get status_put {
    return Intl.message('Put (+)', name: 'status_put', desc: '', args: []);
  }

  /// `Pull (-)`
  String get status_pull {
    return Intl.message('Pull (-)', name: 'status_pull', desc: '', args: []);
  }

  /// `No data`
  String get no_data {
    return Intl.message('No data', name: 'no_data', desc: '', args: []);
  }

  /// `Category`
  String get category_label {
    return Intl.message('Category', name: 'category_label', desc: '', args: []);
  }

  /// `Client Name`
  String get client_name_label {
    return Intl.message(
      'Client Name',
      name: 'client_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Status:`
  String get status_label {
    return Intl.message('Status:', name: 'status_label', desc: '', args: []);
  }

  /// `Amount`
  String get amount_label {
    return Intl.message('Amount', name: 'amount_label', desc: '', args: []);
  }

  /// `Add Transaction`
  String get add_transaction {
    return Intl.message(
      'Add Transaction',
      name: 'add_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Edit Transaction`
  String get edit_transaction {
    return Intl.message(
      'Edit Transaction',
      name: 'edit_transaction',
      desc: '',
      args: [],
    );
  }

  /// `{amount} EGP`
  String currency_egp(Object amount) {
    return Intl.message(
      '$amount EGP',
      name: 'currency_egp',
      desc: '',
      args: [amount],
    );
  }

  /// `Final Total`
  String get final_total {
    return Intl.message('Final Total', name: 'final_total', desc: '', args: []);
  }

  /// `Total Pull (-)`
  String get total_pull {
    return Intl.message(
      'Total Pull (-)',
      name: 'total_pull',
      desc: '',
      args: [],
    );
  }

  /// `Total Put (+)`
  String get total_put {
    return Intl.message('Total Put (+)', name: 'total_put', desc: '', args: []);
  }

  /// `No Transactions Found`
  String get no_transactions_found {
    return Intl.message(
      'No Transactions Found',
      name: 'no_transactions_found',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions_appbar {
    return Intl.message(
      'Transactions',
      name: 'transactions_appbar',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
