
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../config/local_notifications/local_notifications_config.dart';
import '../../domain/entities/push_message.dart';
import '../../firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_handleStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);
    _initialStatusCheck();
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    await LocalNotificationsConfig.requestPermission();

    add(NotificationStatusChanged(settings.authorizationStatus));
    
  }

  void _handleStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      status: event.status
    ));
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications: [ ...state.notifications, event.notification ]
    ));
  }


  Future<void> _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
    _getFCMToken(settings);
  }

  Future<void> _getFCMToken(NotificationSettings settings) async {
    if( settings.authorizationStatus != AuthorizationStatus.authorized ) return;
    final token = await messaging.getToken();

    log(token ?? '');
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null ) return;

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );

    add(NotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  PushMessage? getMessageById( String pushMessageId ) {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    
    if( !exist ) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }
}
