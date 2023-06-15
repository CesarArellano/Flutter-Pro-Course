import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/counter_bloc/counter_bloc.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const CounterBlocView(),
    );
  }
}

class CounterBlocView extends StatelessWidget {
  const CounterBlocView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final counterBloc = context.read<CounterBloc>();
    
    return Scaffold(
      appBar: AppBar(
        title: context.select((CounterBloc counterBloc) {
          return Text('Bloc Counter ${ counterBloc.state.transactionCount }');
        }),
        actions: [
          IconButton(
            onPressed: () => counterBloc.add(CounterReset()),
            icon: const Icon(Icons.refresh_outlined)
          )
        ],
      ),
      body: Center(
        child: context.select((CounterBloc counterBloc) {
          return Text('Counter Value: ${ counterBloc.state.counter }');
        })
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '1',
            child: const Text('+3'),
            onPressed: () => counterBloc.add(CounterIncreased(3)),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: '2',
            child: const Text('+2'),
            onPressed: () => counterBloc.add(CounterIncreased(2)),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: '3',
            child: const Text('+1'),
            onPressed: () => counterBloc.add(CounterIncreased(1)),
          ),
        ],
      ),
    );
  }
}
