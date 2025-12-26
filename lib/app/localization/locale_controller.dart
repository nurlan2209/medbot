import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleController extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _key = 'locale_code';

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final code = await _storage.read(key: _key);
    if (code == 'ru' || code == 'kk') {
      _locale = Locale(code!);
    } else {
      _locale = null;
    }
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale == null) {
      await _storage.delete(key: _key);
    } else {
      await _storage.write(key: _key, value: locale.languageCode);
    }
    notifyListeners();
  }

  Future<void> setLanguageCode(String code) => setLocale(Locale(code));
}

class LocaleControllerScope extends InheritedNotifier<LocaleController> {
  const LocaleControllerScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleControllerScope>();
    assert(scope != null, 'LocaleControllerScope not found');
    return scope!.notifier!;
  }
}
