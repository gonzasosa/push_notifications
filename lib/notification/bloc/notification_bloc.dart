import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationState.initial()) {
    on<_NotificationOpened>(_onNotificationOpened);
    on<_NotificationInForegroundReceived>(_onNotificationInForegroundReceived);
    _notificationRepository.onNotificationOpened.listen(_onNotification);
    _notificationRepository.onForegroundNotification.listen(
      _onForegroundNotification,
    );
  }

  final NotificationRepository _notificationRepository;

  void _onNotification(Notification notification) {
    add(_NotificationOpened(notification: notification));
  }

  void _onForegroundNotification(Notification notification) {
    add(_NotificationInForegroundReceived(notification: notification));
  }

  void _onNotificationOpened(
    _NotificationOpened event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(notification: event.notification));
  }

  void _onNotificationInForegroundReceived(
    _NotificationInForegroundReceived event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(notification: event.notification));
  }
}
