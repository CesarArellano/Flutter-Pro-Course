import 'package:flutter/material.dart';

class CounterScreen extends StatelessWidget {
  static const String name = 'counter_screen';
  
  const CounterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    const counter = 10;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Screen'),
      ),
      body: const Center(
        child: Text('Value: $counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}