import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExampleLocalizations {
  static ExampleLocalizations of(BuildContext context) =>
      Localizations.of<ExampleLocalizations>(context, ExampleLocalizations);

  const ExampleLocalizations(this._count);

  final int _count;

  String get title => 'Tapped $_count times';
}

class ExampleLocalizationsDelegate
    extends LocalizationsDelegate<ExampleLocalizations> {
  const ExampleLocalizationsDelegate(this.count);

  final int count;

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<ExampleLocalizations> load(Locale locale) =>
      SynchronousFuture(ExampleLocalizations(count));

  @override
  bool shouldReload(ExampleLocalizationsDelegate old) => old.count != count;
}
