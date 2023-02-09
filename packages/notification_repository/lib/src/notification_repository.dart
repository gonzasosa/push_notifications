import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

/// {@template notification_repository}
/// A repository for the Notifications domain baked with [FirebaseMessaging].
/// {@endtemplate}
class NotificationRepository {
  /// {@macro notification_repository}
  NotificationRepository({
    FirebaseMessaging? firebaseMessaging,
    Stream<RemoteMessage>? onNotificationOpened,
    Stream<RemoteMessage>? onForegroundNotification,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _onForegroundNotification =
            onForegroundNotification ?? FirebaseMessaging.onMessage,
        _onNotificationOpenedController = BehaviorSubject<Notification>() {
    _initialize(onNotificationOpened ?? FirebaseMessaging.onMessageOpenedApp);
  }

  final FirebaseMessaging _firebaseMessaging;
  final Stream<RemoteMessage> _onForegroundNotification;
  final BehaviorSubject<Notification> _onNotificationOpenedController;

  Future<void> _initialize(Stream<RemoteMessage> onNotificationOpened) async {
    final response = await _firebaseMessaging.requestPermission();
    final status = response.authorizationStatus;
    if (status == AuthorizationStatus.authorized) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final message = await _firebaseMessaging.getInitialMessage();
      print('Device token: ${await _firebaseMessaging.getToken()}');
      if (message != null) {
        _onMessageOpened(message);
      }
      onNotificationOpened.listen(_onMessageOpened);
    }
  }

  void _onMessageOpened(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _onNotificationOpenedController.sink.add(
        Notification(
          title: notification.title ?? '',
          body: notification.body ?? '',
        ),
      );
    }
  }

  /// Returns a [Stream] that emits when a user presses a [Notification]
  /// message displayed via FCM.
  ///
  /// If your app is opened via a notification whilst the app is terminated,
  /// see [FirebaseMessaging.getInitialMessage].
  Stream<Notification> get onNotificationOpened {
    return _onNotificationOpenedController.stream;
  }

  /// Returns a [Stream] that emits when an incoming [Notification] is
  /// received whilst the Flutter instance is in the foreground.
  Stream<Notification> get onForegroundNotification {
    return _onForegroundNotification.mapNotNull((message) {
      final notification = message.notification;
      if (notification == null) {
        return null;
      }
      return Notification(
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    });
  }
}
