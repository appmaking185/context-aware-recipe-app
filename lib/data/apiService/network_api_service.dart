import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ivtexsolutionsapp/core/failure.dart';
import 'package:ivtexsolutionsapp/core/logger.dart';
import 'package:ivtexsolutionsapp/resources/config_file.dart';
import 'package:ivtexsolutionsapp/resources/string_resources.dart';
import 'base_api_service.dart';

class NetworkAPIService implements BaseAPIService {
  final Dio _dio;
  final InternetConnectionChecker connectionChecker;
  final String _token = '';

  /*  final FirebaseMessaging _firebaseMessaging;*/

  NetworkAPIService(this._dio, this.connectionChecker);

  @override
  Future<void> initiateLogoutProcess() async {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      //
    });
  }

  @override
  Future<Either<Failure, dynamic>> executeAPI({
    required String url,
    required Map<String, dynamic> queryParameters,
    bool isClientToken = false,

    FormData? formData,
    required ApiType apiType,
  }) async {
    // Create a json web token

    // bool result = await connectionChecker.hasConnection; // It's taking too much time to check the connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      logger.i('URL : $url \n Request:  $queryParameters');

      try {
        late Response response;
        final headerOptions = await getHeaderOptions(
          isClientToken: isClientToken,
        );

        if (apiType == ApiType.GET) {
          response = queryParameters.isEmpty
              ? await _dio.get(url, options: headerOptions)
              : await _dio.get(
                  url,
                  queryParameters: queryParameters,
                  options: headerOptions,
                );
        } else if (apiType == ApiType.POST) {
          response = await _dio.post(
            url,
            data: queryParameters,
            options: headerOptions,
          );
        } else if (apiType == ApiType.PUT) {
          response = await _dio.put(
            url,
            data: queryParameters,
            options: headerOptions,
          );
        } else if (apiType == ApiType.PATCH) {
          response = await _dio.patch(
            url,
            data: queryParameters,
            options: headerOptions,
          );
        } else if (apiType == ApiType.MULTIPART) {
          response = await _dio.post(
            url,
            data: formData,
            options: headerOptions,
          );
        } else {
          response = await _dio.delete(
            url,
            data: queryParameters,
            options: headerOptions,
          );
        }
        logger.i('URL : $url \n Response : ${response.data}');

        return right(response.data);
      } on DioException catch (e) {
        String message = '';
        int errorCode = 101;
        if (e.response != null) {
          try {
            message = e.response!.data['message'].toString();
            if (message == "null" || message.isEmpty) {
              message = e.response!.data['error']['message'].toString();
            }
          } catch (e) {
            logger.e(e);
            message = e.toString();
          }
          errorCode = e.response!.statusCode ?? ConfigFile.noInternetErrorCode;
          logger.e(
            'the error message : $message\n'
            'the status code :${e.response}\n'
            'Status Code is $errorCode',
          );
        }
        if (message.isEmpty) {
          message = StringResources.errorTitle;
        }
        return left(Failure(message, statusCode: errorCode));
      } on SocketException catch (e) {
        logger.e(e);
        return left(
          const Failure(
            StringResources.checkInternetConnection,
            statusCode: ConfigFile.noInternetErrorCode,
          ),
        );
      } on TypeError catch (e) {
        logger.e(e);
        return left(
          const Failure(
            StringResources.responseTypeError,
            statusCode: ConfigFile.unExpectedErrorCode,
          ),
        );
      } on Exception catch (e) {
        logger.e(e);
        return left(
          const Failure(
            StringResources.unexpectedErrorOccurred,
            statusCode: ConfigFile.unExpectedErrorCode,
          ),
        );
      }
    } else {
      return left(
        const Failure(
          StringResources.checkInternetConnection,
          statusCode: ConfigFile.noInternetErrorCode,
        ),
      );
    }
  }

  @override
  Future<String> getJWTToken() async {
    return "";
  }

  @override
  Future<Options> getHeaderOptions({required bool isClientToken}) async {
    logger.i('Token : $_token');
    Map<String, String> headers = {
      "Authorization": 'Bearer $_token',
      'device_type': Platform.isIOS ? 'ios' : 'android',
    };
    return Options(
      receiveTimeout: const Duration(milliseconds: 60000),
      headers: headers,
    );
  }
}

//400
// Bad Request
//
// 401
// Unauthorized
//
// 402
// Payment Required
//
// 403
// Forbidden and show Pop for informing user that you are not verified yet to access all the service's within app.
//
// 404
// Not Found
//
// 408
// Login session expired
//
// 500
// Internal Server Error
