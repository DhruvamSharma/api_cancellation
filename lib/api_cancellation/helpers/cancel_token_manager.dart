import 'dart:developer';

import 'package:dio/dio.dart';

/// Singleton class that manages cancel tokens based on string tags.
/// Provides easy access to cancel tokens and automatic cleanup.
class CancelTokenManager {
  factory CancelTokenManager() => _instance;
  CancelTokenManager._internal();
  static final CancelTokenManager _instance = CancelTokenManager._internal();

  // Predefined tag constants for easy access
  static const String manualRequest = 'manual_request';
  static const String searchRequest = 'search_request';
  static const String pageRequest = 'page_request';

  // Map to store cancel tokens by tag
  final Map<String, CancelToken> _cancelTokens = {};

  /// Get a cancel token for the specified tag.
  /// If no token exists, creates a new one.
  CancelToken getToken(String tag, {bool forceNew = false}) {
    if (!_cancelTokens.containsKey(tag)) {
      _cancelTokens[tag] = CancelToken();
    }

    // cancel any previous request
    if (forceNew) {
      cancelRequest(tag);
      _cancelTokens[tag] = CancelToken();
    }
    return _cancelTokens[tag]!;
  }

  /// Cancel a specific request by tag.
  /// Returns true if the token was cancelled, false if it didn't exist.
  bool cancelRequest(String tag, {String? reason}) {
    final token = _cancelTokens[tag];
    if (token != null && !token.isCancelled) {
      token.cancel(reason ?? 'Request cancelled by manager');
      log('Cancelled request with tag: $tag');
      return true;
    }
    return false;
  }

  /// Cancel all active requests.
  void cancelAllRequests({String? reason}) {
    for (final entry in _cancelTokens.entries) {
      if (!entry.value.isCancelled) {
        entry.value.cancel(reason ?? 'All requests cancelled');
      }
    }
  }


  /// Dispose the manager and cancel all requests.
  void dispose() {
    cancelAllRequests(reason: 'Manager disposed');
    _cancelTokens.clear();
  }
}
