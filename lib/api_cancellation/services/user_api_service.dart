import 'package:api_cancellation/api_cancellation/helpers/cancel_token_manager.dart';
import 'package:api_cancellation/api_cancellation/helpers/user_entity.dart';
import 'package:api_cancellation/api_cancellation/services/abstract_api_service.dart';

/// Concrete implementation of AbstractApiService for user-related API calls.
class UserApiService extends AbstractApiService {
  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  @override
  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  @override
  Duration get timeout => const Duration(seconds: 15);

  @override
  String get cancelTokenTag => CancelTokenManager.manualRequest;

  /// Fetch user profile information.
  Future<List<UserEntity>> getUserProfiles() async {
    try {
      final response = await get<dynamic>(
        '/comments',
        tag: CancelTokenManager.manualRequest,
      );

      final userProfiles = <UserEntity>[];

      if (response is List) {
        for (final item in response) {
          if (item is Map<String, dynamic>) {
            final user = UserEntity(
              id: item['id'].toString(),
              name: item['name']?.toString() ?? 'Unknown',
            );
            userProfiles.add(user);
          }
        }
        return userProfiles;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}
