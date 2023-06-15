part of 'counter_bloc.dart';

class CounterState extends Equatable {
  final int counter;
  final int transactionCount;

  const CounterState({
    this.counter = 5,
    this.transactionCount = 0,
  });

  CounterState copyWith({
    int? counter,
    int? transactionCount,
  }) => CounterState(
    counter: counter ?? this.counter,
    transactionCount: transactionCount ?? this.transactionCount
  );

  @override
  List<Object> get props => [counter, transactionCount];
}

class CounterIncreased extends CounterEvent {
  final int value;
  
  CounterIncreased(this.value);
}

class CounterReset extends CounterEvent {}