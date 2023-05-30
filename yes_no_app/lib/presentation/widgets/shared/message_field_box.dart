import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({
    super.key,
    required this.onValue
  });

  final ValueChanged<String> onValue;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();

    return TextFormField(
      focusNode: focusNode,
      onTapOutside: ( _ ) => focusNode.unfocus(),
      controller: textController,
      decoration: InputDecoration(
        filled: true,
        hintText: 'End your message with "?"',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send_outlined),
          onPressed: () {
            final value = textController.text;
            onValue(value);
            textController.clear();
          },
        ),
      ),
      onFieldSubmitted: (value) {
        onValue(value);
        textController.clear();
        focusNode.requestFocus();
      },
    );
  }
}