import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/blocs/notifications/notifications_bloc.dart';
import 'package:push_app/domain/entities/push_message.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;

  const DetailsScreen({
    Key? key,
    required this.pushMessageId
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final notification = context.watch<NotificationsBloc>().getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Details'),
      ),
      body: notification != null
        ? _DetailsView(
          notification: notification,
        )
        : const Center( child: Text("This notification doesn't exist"))
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage notification;

  const _DetailsView({
    required this.notification
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if( notification.imageUrl != null )
            Image.network(notification.imageUrl!),
          const SizedBox(height: 30),
          Text(notification.title, style: textStyles.titleMedium),
          Text(notification.body),
          const Divider(),
          Text(notification.data.toString())
        ],
      ),
    );
  }
}