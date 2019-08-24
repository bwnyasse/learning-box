
import 'package:counter_with_provider/i18n/localization.dart';
import 'package:counter_with_provider/widgets/counter_label.dart';
import 'package:counter_with_provider/widgets/increment_button.dart';
import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(ExampleLocalizations.of(context).title);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Title()),
      body: const Center(child: CounterLabel()),
      floatingActionButton:  IncrementCounterButton(),
    );
  }
}