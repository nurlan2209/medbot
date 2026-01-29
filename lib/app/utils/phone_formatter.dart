import 'package:flutter/services.dart';

class KzPhoneFormatter extends TextInputFormatter {
  const KzPhoneFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\\D'), '');
    var rest = digits;
    if (rest.startsWith('7') || rest.startsWith('8')) {
      rest = rest.substring(1);
    }
    if (rest.length > 10) rest = rest.substring(0, 10);

    final p1 = rest.substring(0, rest.length.clamp(0, 3));
    final p2 = rest.length > 3 ? rest.substring(3, rest.length.clamp(3, 6)) : '';
    final p3 = rest.length > 6 ? rest.substring(6, rest.length.clamp(6, 8)) : '';
    final p4 = rest.length > 8 ? rest.substring(8, rest.length.clamp(8, 10)) : '';

    final buffer = StringBuffer('+7');
    if (p1.isNotEmpty) {
      buffer.write(' ($p1');
      if (p1.length == 3) buffer.write(')');
    }
    if (p2.isNotEmpty) buffer.write(' $p2');
    if (p3.isNotEmpty) buffer.write('-$p3');
    if (p4.isNotEmpty) buffer.write('-$p4');

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
