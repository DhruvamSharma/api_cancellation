import 'package:api_cancellation/api_cancellation/helpers/cancel_token_manager.dart';
import 'package:api_cancellation/app/view/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Abstract base class for API services that provides common functionality
/// and integrates with the CancelTokenManager for request cancellation.
abstract class AbstractApiService {
  AbstractApiService({Dio? dio})
      : _dio = dio ?? Dio(),
        _tokenManager = CancelTokenManager();
  final Dio _dio;
  final CancelTokenManager _tokenManager;

  /// Get a cancel token for the specified tag.
  /// If no token exists, creates a new one.
  CancelToken getToken(String tag, {bool forceNew = false}) =>
      _tokenManager.getToken(
        tag,
        forceNew: forceNew,
      );

  /// Cancel a specific request by tag.
  bool cancelRequest(String tag, {String? reason}) =>
      _tokenManager.cancelRequest(tag, reason: reason);

  /// Abstract method that subclasses must implement to provide the base URL.
  String get baseUrl;

  /// Abstract method that subclasses must implement to provide default headers.
  Map<String, String> get defaultHeaders => {};

  /// Abstract method that subclasses must implement to provide request timeout.
  Duration get timeout => const Duration(seconds: 30);

  /// Abstract method that subclasses must implement to provide the cancel token tag
  /// for this service instance.
  String get cancelTokenTag;

  /// Configure Dio with common settings.
  void _configureDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    _dio.options.headers.addAll(defaultHeaders);
  }

  /// GET request with automatic token management.
  ///
  /// [endpoint] - The API endpoint (e.g., '/users', '/posts')
  /// [queryParameters] - Optional query parameters
  /// [options] - Optional request options
  /// [tag] - Optional custom tag for cancellation (defaults to service's tag)
  ///
  /// Returns the response data of type T.
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? tag,
  }) async {
    // Configure Dio if not already configured
    _configureDio();

    // Get the cancel token for this request
    final cancelToken = getToken(tag ?? cancelTokenTag, forceNew: true);
    final context = navigatorKey.currentContext;
    final scaffoldState =
        context != null ? ScaffoldMessenger.of(context) : null;
    try {
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options ?? Options(),
        cancelToken: cancelToken,
      );

      // Check if the request was cancelled
      if (cancelToken.isCancelled) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Request was cancelled',
        );
      }

      return response.data as T;
    } catch (e) {
      if (e is DioException &&
          e.message == 'The request was manually cancelled by the user.') {
        // also show a snackbar
        if (scaffoldState != null) {
          scaffoldState.showSnackBar(
            const SnackBar(
              content: Text('Request was cancelled'),
              behavior: SnackBarBehavior.floating,
            ),
            
          );
        }
      }
      throw _handleError(e, endpoint);
    }
  }

  /// Handle and transform errors into a consistent format.
  Exception _handleError(dynamic error, String endpoint) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('Connection timeout for $endpoint');
        case DioExceptionType.sendTimeout:
          return Exception('Send timeout for $endpoint');
        case DioExceptionType.receiveTimeout:
          return Exception('Receive timeout for $endpoint');
        case DioExceptionType.badResponse:
          return Exception(
              'Bad response (${error.response?.statusCode}) for $endpoint');
        case DioExceptionType.cancel:
          return Exception('Request cancelled for $endpoint');
        case DioExceptionType.connectionError:
          return Exception('Connection error for $endpoint');
        case DioExceptionType.badCertificate:
          return Exception('Bad certificate for $endpoint');
        case DioExceptionType.unknown:
          return Exception('Unknown error for $endpoint');
      }
    }
    return Exception('Unexpected error for $endpoint: $error');
  }

  /// Cancel all requests managed by this service.
  void cancelAllRequests({String? reason}) {
    _tokenManager.cancelRequest(cancelTokenTag, reason: reason);
  }

  /// Dispose the service and cancel all its requests.
  void dispose() {
    cancelAllRequests(reason: 'Service disposed');
  }
}
