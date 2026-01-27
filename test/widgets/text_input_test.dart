import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_bot/app/widgets/text_input.dart';

void main() {
  testWidgets('работает', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextInput(controller: controller, isPassword: true),
        ),
      ),
    );

    TextField textField = tester.widget(find.byType(TextField));
    expect(textField.obscureText, true);

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    textField = tester.widget(find.byType(TextField));
    expect(textField.obscureText, false);
  });
}