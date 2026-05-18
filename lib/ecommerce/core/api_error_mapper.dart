import 'package:dio/dio.dart';

class ApiErrorMapper {
  ApiErrorMapper._();

  static String message(Object error) {
    if (error is DioException) {
      return _fromDio(error);
    }
    final text = error.toString();
    if (_looksLikeOffline(text)) {
      return 'No internet connection. Check your network and try again.';
    }
    if (text.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  static String _fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Check your network and try again.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) return 'Requested data was not found.';
        if (code != null && code >= 500) {
          return 'Server error ($code). Please try again later.';
        }
        return 'Unable to load data (HTTP $code).';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (_looksLikeOffline(error.message ?? '')) {
          return 'No internet connection. Check your network and try again.';
        }
        return error.message ?? 'Something went wrong. Please try again.';
    }
  }

  static bool _looksLikeOffline(String text) {
    final lower = text.toLowerCase();
    return lower.contains('socket') ||
        lower.contains('network') ||
        lower.contains('failed host lookup') ||
        lower.contains('connection refused') ||
        lower.contains('no address associated');
  }
}
