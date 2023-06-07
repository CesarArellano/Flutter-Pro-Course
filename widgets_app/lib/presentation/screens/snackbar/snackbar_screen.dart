import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SnackbarScreen extends StatelessWidget {
  static const String name = 'snackbar_screen';
  
  const SnackbarScreen({Key? key}) : super(key: key);
  
  void showCustomSnackBar( BuildContext context ) {

    ScaffoldMessenger.of(context).clearSnackBars();
    
    const snackbar = SnackBar(
      content: Text('Hello World!')
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snackbar and Dialogs'),
      ),
      body: const _SnackbarView(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.remove_red_eye_outlined),
        label: const Text('Show snackbar'),
        onPressed: () => showCustomSnackBar(context)
      ),
    );
  }
}

class _SnackbarView extends StatelessWidget {
  const _SnackbarView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.tonal(
            child: const Text('Used Licenses'),
            onPressed: () => openLicensesDialog(context)
          ),
          FilledButton.tonal(
            child: const Text('Show dialog'),
            onPressed: () => openDialog(context)
          ),
        ],
      )
    );
  }

  void openLicensesDialog( BuildContext context ) {
    showAboutDialog(
      context: context,
      children: [
        const Text('Lorem Impsu')
      ]
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: ( _ ) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Content'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel')
          ),
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('Acept')
          )
        ],
      )
    );
  }
}

