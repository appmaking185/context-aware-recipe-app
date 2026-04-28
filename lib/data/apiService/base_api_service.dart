import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/failure.dart';

// ignore: constant_identifier_names
enum ApiType { GET, POST, PUT, DELETE, PATCH, MULTIPART }

abstract class BaseAPIService {
  Future<Either<Failure, dynamic>> executeAPI({
    required String url,
    required Map<String, dynamic> queryParameters,
    bool isClientToken = true,
    FormData? formData,
    required ApiType apiType,
  });

  Future<void> initiateLogoutProcess();

  Future<String> getJWTToken();

  Future<Options> getHeaderOptions({required bool isClientToken});
}
