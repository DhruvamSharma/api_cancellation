part of 'api_cancellation_bloc.dart';

@immutable
class ApiCancellatioState {
  const ApiCancellatioState({
    required this.usersState,
    required this.requestCount,
    required this.requestsCancelled,
    required this.requestsCompleted,
  });

  factory ApiCancellatioState.initial() => const ApiCancellatioState(
    usersState: DataFieldInitial(),
    requestCount: 0,
    requestsCancelled: 0,
    requestsCompleted: 0,
  );

  final DataField<List<UserEntity>> usersState;
  final int requestCount;
  final int requestsCancelled;
  final int requestsCompleted;

  ApiCancellatioState copyWith({
    DataField<List<UserEntity>>? usersState,
    int? requestCount,
    int? requestsCancelled,
    int? requestsCompleted,
  }) {
    return ApiCancellatioState(
      usersState: usersState ?? this.usersState,
      requestCount: requestCount ?? this.requestCount,
      requestsCancelled: requestsCancelled ?? this.requestsCancelled,
      requestsCompleted: requestsCompleted ?? this.requestsCompleted,
    );
  }
}
