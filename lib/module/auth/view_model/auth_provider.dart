import 'package:custom_datepicker/helpers/session_manager.dart';
import 'package:custom_datepicker/module/auth/repository/auth_repository.dart';
import 'package:custom_datepicker/network/response_model.dart';
import 'package:custom_datepicker/utils/routes/routes_names.dart';
import 'package:custom_datepicker/utils/utils.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepo;
  final SessionManager sessionManager;

  AuthProvider({required this.authRepo, required this.sessionManager}) {
    sessionManager.getSession().then((value) {
      //_userData = value;
    });
  }

  bool _showLoader = false;
  bool _showButtonLoader = false;

  bool get showLoader => _showLoader;

  bool get showButtonLoader => _showButtonLoader;
  bool _isShowNewPassword = false;

  get isShowNewPassword => _isShowNewPassword;

  List<String> _pinCodeList = [];

  List<String> get pinCodeList => _pinCodeList;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updatePasswordStatus(bool value) {
    _isShowNewPassword = value;
    notifyListeners();
  }

  _setShowLoader(bool value) {
    _showLoader = value;
    notifyListeners();
  }

  _setButtonLoader(bool value) {
    _showButtonLoader = value;
    notifyListeners();
  }

  login({
    String? email,
    String? password,
    required BuildContext context,
  }) async {
    _setButtonLoader(true);
    var res = await authRepo.login(
      email: email ?? "",
      password: password ?? "",
    );
    res.fold(
      (String message) {
        Utils.flushBarErrorMessage(message, context);
        _setButtonLoader(false);
      },
      (ResponseModel response) {
        _setButtonLoader(false);
        if (response.statusCode == 200) {
          //  _userData = JobsApp.fromJson(response.data);
          // sessionManager.setSession(_userData!);
          sessionManager.setUserId(response.data['user_id'].toString());
          notifyListeners();
          Utils.toastMessage(context, message: response.msg ?? "");

          ///Navigate according to your screen
        } else {
          Utils.flushBarErrorMessage(response.msg ?? "", context);
        }
        notifyListeners();
      },
    );
  }

  Future<void> validateNavigation(BuildContext context) async {
    final isWalkthroughCompleted = await sessionManager.isWalkThrough();

    ///navigate according to your screen

    if (isWalkthroughCompleted) {
      if (context.mounted) {
        Navigator.popAndPushNamed(context, RouteNames.splashScreen);
      }
      return;
    }

    final userId = await sessionManager.getUserId();
    if (userId.isEmpty) {
      if (context.mounted) {
        Navigator.popAndPushNamed(context, RouteNames.splashScreen);
      }
      return;
    }

    final session = await sessionManager.getSession();

    if (context.mounted) {
      Navigator.popAndPushNamed(context, RouteNames.splashScreen);
    }
  }

  setWalkThrough(BuildContext context) {
    sessionManager.setWalkThrough().then((value) {
      if (context.mounted) {
        Navigator.pushNamed(context, RouteNames.splashScreen);
      }
    });
  }

  logout(BuildContext context) async {
    await sessionManager.clearSession();
    if (context.mounted) {
      Navigator.popAndPushNamed(context, RouteNames.splashScreen);
    }
  }
}
