import 'package:custom_datepicker/module/auth/repository/auth_repository.dart';
import 'package:custom_datepicker/network/api_client.dart';
import 'package:custom_datepicker/network/response_model.dart';
import 'package:custom_datepicker/network/server_error.dart';
import 'package:fpdart/fpdart.dart';

class AuthService implements AuthRepository {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  @override
  Future<Either<String, ResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      var res = await apiClient.postApi(
        url: "Your URL",
        body: {'phone': email, 'password': password},
      );
      return Right(res!);
    } on ServerError catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
