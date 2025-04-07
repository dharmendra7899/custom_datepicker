import 'package:custom_datepicker/helpers/session_manager.dart';
import 'package:custom_datepicker/module/auth/repository/auth_repository.dart';
import 'package:custom_datepicker/module/auth/view_model/auth_service.dart';
import 'package:custom_datepicker/network/api_client.dart';
import 'package:custom_datepicker/network/api_client_imp.dart';
import 'package:custom_datepicker/network/socket_service_imp.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

init() async {
  var pref = await SharedPreferences.getInstance();

  //network
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClientImp(sessionManager: serviceLocator()),
  );

  //socket
  serviceLocator.registerLazySingleton<SocketService>(
    () => SocketServiceImp(url: 'ws://13.61.83.27:5002'),

    ///add your socket url
  );

  //session
  serviceLocator.registerLazySingleton<SessionManager>(
    () => SessionManagerImp(sharedPreferences: pref),
  );

  //auth
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthService(apiClient: serviceLocator()),
  );
}
