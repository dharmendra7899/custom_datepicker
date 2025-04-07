import 'package:custom_datepicker/network/response_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<String, ResponseModel>> login({
    required String email,
    required String password,
  });
}
