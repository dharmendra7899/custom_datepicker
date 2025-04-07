import 'package:custom_datepicker/helpers/notification_service.dart';
import 'package:custom_datepicker/theme/theme.dart';
import 'package:custom_datepicker/utils/routes/routes.dart';
import 'package:custom_datepicker/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // NotificationServices notificationServices = NotificationServices();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   notificationServices.requestNotificationPermission();
  //   notificationServices.foregroundMessage();
  //   notificationServices.firebaseInit(context);
  //   notificationServices.setupInteractMessage(context);
  //   notificationServices.getDeviceToken().then((value) {});
  //   // InitZohoSalesIQ.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      locale: Locale('en'),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splashScreen,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
