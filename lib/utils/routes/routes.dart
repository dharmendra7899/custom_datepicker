import 'package:custom_datepicker/slot_screen.dart';
import 'package:custom_datepicker/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (_) => const SlotScreen());

      // case RouteNames.jobDetailScreen:
      //   final args = settings.arguments as Map<String, dynamic>? ?? {};
      //   final int serviceTypeId = args['serviceTypeId'] ?? 0;
      //   final int serviceId = args['serviceId'] ?? 0;
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => JobDetailScreen(
      //           serviceTypeId: serviceTypeId,
      //           serviceId: serviceId,
      //         ),
      //   );

      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text("No route is configured")),
              ),
        );
    }
  }
}
