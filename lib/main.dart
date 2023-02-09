import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:push_notifications/chat/view/chat_page.dart';
import 'package:push_notifications/firebase_options.dart';
import 'package:push_notifications/navigation/client/client.dart';
import 'package:push_notifications/notification/notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final navigatorKey = GlobalKey<NavigatorState>();
  final navigatorStateClient = NavigatorStateClient(navigatorKey: navigatorKey);
  final notificationRepository = NotificationRepository();
  ChatNotificationRoute(client: navigatorStateClient).register(
    notificationRepository.onNotificationOpened,
  );
  runApp(
    App(
      navigatorKey: navigatorKey,
      notificationRepository: notificationRepository,
    ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    required GlobalKey<NavigatorState> navigatorKey,
    required NotificationRepository notificationRepository,
  })  : _navigatorKey = navigatorKey,
        _notificationRepository = notificationRepository;

  final GlobalKey<NavigatorState> _navigatorKey;
  final NotificationRepository _notificationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _notificationRepository,
      child: BlocProvider(
        lazy: false,
        create: (context) => NotificationBloc(
          notificationRepository: context.read<NotificationRepository>(),
        ),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Push Notifications Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Scaffold(
            body: Center(child: Text('Hola')),
          ),
        ),
      ),
    );
  }
}

class SomePage extends StatelessWidget {
  const SomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return const SomePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
