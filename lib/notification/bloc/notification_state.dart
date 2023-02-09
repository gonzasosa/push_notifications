part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState({this.notification});

  const NotificationState.initial() : this();

  final Notification? notification;

  @override
  List<Object?> get props => [notification];

  NotificationState copyWith({
    Notification? notification,
  }) {
    return NotificationState(
      notification: notification ?? this.notification,
    );
  }
}
