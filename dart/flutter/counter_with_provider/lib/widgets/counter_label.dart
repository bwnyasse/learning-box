import 'package:counter_with_provider/provider/counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterLabel extends StatelessWidget {
  const CounterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '${counter.count}',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}