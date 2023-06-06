import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonsScreen extends StatelessWidget {
  
  static const String name = 'buttons_screen';

  const ButtonsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons Screen'),
      ),
      body: const _ButtonsView(),
      floatingActionButton: ( context.canPop() )
        ? FloatingActionButton(
          onPressed: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new),
        )
        : null
    );
  }
}

class _ButtonsView extends StatelessWidget {
  const _ButtonsView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Elevated'),
              onPressed: (){}
            ),
            const ElevatedButton(
              onPressed: null,
              child: Text('Elevated Disabled')
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.access_alarm_rounded),
              label: const Text('Elevated Icon')
            ),
            FilledButton(
              child: const Text('Filled'),
              onPressed: (){}
            ),
            FilledButton.icon(
              icon: const Icon(Icons.accessibility_new),
              label: const Text('Filled Icon'),
              onPressed: (){}
            ),
            OutlinedButton(
              child: const Text('Outlined'),
              onPressed: (){}
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.terminal),
              label: const Text('Outlined Icon'),
              onPressed: (){}
            ),
            TextButton(
              child: const Text('Text Btn'),
              onPressed: (){}
            ),
            TextButton.icon(
              icon: const Icon(Icons.abc_outlined),
              label: const Text('Text Btn Icon'),
              onPressed: (){}
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon( Icons.app_registration_rounded ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon( Icons.app_registration_rounded ),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: colors.primary
              ),
            ),
          ],
        ),
      ),
    );
  }
}