import 'package:counter_with_provider/provider/counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncrementCounterButton extends StatelessWidget {
  const IncrementCounterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // `listen: false` is specified here because otherwise that would make
        // `IncrementCounterButton` rebuild when the counter updates.
        Provider.of<Counter>(context, listen: false).increment();
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}