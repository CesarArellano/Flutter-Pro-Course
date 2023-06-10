import 'package:flutter/material.dart';

const messages = <String>[
  'Loading movies',
  'Buying pop corns',
  'Loading populars',
  'Calling to my girlfriend',
  'Almost there',
  'This took longer than expected'
];

Stream<String> getLoadingMessages() {
  return Stream.periodic(const Duration(milliseconds: 1200), (step) {
    return messages[step];
  });
}

class FullScreenLoader extends StatelessWidget {
  
  const FullScreenLoader({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Please wait'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2,),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if( !snapshot.hasData ) return const Text('Loading...');
              return Text(snapshot.data!);
            },
          )
        ],
      )
    );
  }
}