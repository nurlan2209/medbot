// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import 'package:med_bot/app/localization/locale_controller.dart';
import 'package:med_bot/main.dart';

void main() {
  testWidgets('App boots to onboarding when logged out', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'read') return null;
      if (call.method == 'write') return null;
      if (call.method == 'delete') return null;
      if (call.method == 'deleteAll') return null;
      return null;
    });

    final localeController = LocaleController();
    await localeController.load();

    await tester.pumpWidget(
      LocaleControllerScope(
        controller: localeController,
        child: MedBotApp(localeController: localeController),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Медицинский помощник'), findsOneWidget);
  });
}
