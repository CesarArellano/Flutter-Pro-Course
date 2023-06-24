import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/notifications/notifications_bloc.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Push App',
      theme: AppTheme().getTheme(),
      builder: (context, child) => HandleNotificationInteractions(child: child!),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  const HandleNotificationInteractions({super.key, required this.child});

  final Widget child;
  @override
  State<HandleNotificationInteractions> createState() => _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState extends State<HandleNotificationInteractions> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
    appRouter.push('/push-details/$messageId');
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}