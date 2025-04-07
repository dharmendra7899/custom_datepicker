import 'package:custom_datepicker/app.dart';
import 'package:custom_datepicker/injection_container.dart' as di;
import 'package:custom_datepicker/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///if want to use firebase in background
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();

  /// initialize firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Providers(widget: const MyApp()));
}
