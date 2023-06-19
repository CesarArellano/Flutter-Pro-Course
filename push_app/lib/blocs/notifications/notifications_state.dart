part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const []
  });
  
  final List<PushMessage> notifications;
  final AuthorizationStatus status;

  NotificationsState copyWith({
    List<PushMessage>? notifications,
    AuthorizationStatus? status,
  }) => NotificationsState(
    notifications: notifications ?? this.notifications,
    status: status ?? this.status
  );


  @override
  List<Object> get props => [ status, notifications ];
}