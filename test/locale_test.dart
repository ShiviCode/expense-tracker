import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/states/expense_provider.dart';

void main() {
  group('Locale Tests', () {
    late ExpenseProvider localeProvider;

    setUp(() {
      localeProvider = ExpenseProvider();
    });

    test('Switching language should toggle between English and Hindi', () {
      // Initial language should be English
      expect(localeProvider.locale.languageCode, 'en');

      // Act: Switch to Spanish
      localeProvider.switchLanguage(const Locale('hi', 'IN'));

      // Assert: Language should be Hindi
      expect(localeProvider.locale.languageCode, 'hi');

      // Act: Switch back to English
      localeProvider.switchLanguage(const Locale('en', 'US'));

      // Assert: Language should be back to English
      expect(localeProvider.locale.languageCode, 'en');
    });
  });
}
