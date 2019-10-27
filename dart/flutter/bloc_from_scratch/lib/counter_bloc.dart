import 'dart:async';

import 'package:bloc_from_scratch/counter_event.dart';


//   |---------|        |-----------|        |-----------|
//   |  EVENT  | ---->  |    BLOC   | ---->  |   STATE   |
//   |---------|        |-----------|        |-----------|


class CounterBloc {
  int _counter = 0;

  // -------
  // EVENT
  // -------
  final _counterEventController = StreamController<CounterEvent>();
  // For state, exposing only a sink which is an input
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  // -------
  // STATE
  // -------
  final _counterStateController = StreamController<int>();
  StreamSink<int> get _inCounter => _counterStateController.sink;
  // For state, exposing only a stream which outputs data
  Stream<int> get counter => _counterStateController.stream;

  CounterBloc() {
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent)
      _counter++;
    else
      _counter--;

    _inCounter.add(_counter);
  }

  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}
