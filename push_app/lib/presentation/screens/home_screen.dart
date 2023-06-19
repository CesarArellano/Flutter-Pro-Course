import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select((NotificationsBloc bloc ) => Text('${ bloc.state.status }')),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsBloc>().requestPermission();
            },
            icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final notificationList = context.watch<NotificationsBloc>().state.notifications;
    return ListView.builder(
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        final notification = notificationList[index];

        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
          leading: notification.imageUrl != null  
            ? Image.network(notification.imageUrl!)
            : null,
          onTap: () => context.push('/push-details/${ notification.messageId }'),
        );
      }
    );
  }
}