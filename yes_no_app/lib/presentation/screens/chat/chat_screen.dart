import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/message.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat/her_message_bubble.dart';
import '../../widgets/chat/my_message_bubble.dart';
import '../../widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  
  const ChatScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi amor 💖'),
        centerTitle: false,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://media.licdn.com/dms/image/D5603AQE_CpTZ1Y3iAg/profile-displayphoto-shrink_200_200/0/1684859001190?e=1690416000&v=beta&t=4ozZSpbSn-xO-hz3M00iEL50nu_anOQEd7xL7jUsFgY'),
          ),
        ),
      ),
      body: const _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();
  
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messageList.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];
          
                return ( message.fromWho == FromWho.hers )
                  ? HerMessageBubble( message: message ) 
                  : MyMessageBubble( message: message );
              }
            ),
          ),
          MessageFieldBox(
            onValue: chatProvider.sendMessage,
          ),
        ],
      ),
    );
  }
}