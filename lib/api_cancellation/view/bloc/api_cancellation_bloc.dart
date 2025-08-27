import 'package:api_cancellation/api_cancellation/helpers/data_field.dart';
import 'package:api_cancellation/api_cancellation/helpers/user_entity.dart';
import 'package:api_cancellation/api_cancellation/services/user_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'api_cancellation_event.dart';
part 'api_cancellation_state.dart';

class ApiCancellatioBloc
    extends Bloc<ApiCancellatioEvent, ApiCancellatioState> {
  ApiCancellatioBloc({
    required this.userApiService,
  }) : super(ApiCancellatioState.initial()) {
    on<StartManualApiRequest>((event, emit) async {
      try {
        emit(
          state.copyWith(
            usersState: const DataFieldLoading(),
            requestCount: state.requestCount + 1,
          ),
        );
        final response = await userApiService.getUserProfiles();
        emit(
          state.copyWith(
            usersState: DataFieldSuccess(response),
            requestsCompleted: state.requestsCompleted + 1,
          ),
        );
      } catch (ex) {
        emit(
          state.copyWith(
            usersState: const DataFieldError('Failed to fetch user profiles'),
            requestsCancelled: state.requestsCancelled + 1,
          ),
        );
      }
    });

    on<CancelManualApiRquest>((event, emit) {
      userApiService.cancelRequest(userApiService.cancelTokenTag);
      emit(
        state.copyWith(
          usersState: const DataFieldError('Request cancelled'),
        ),
      );
    });

    on<ClearStats>((event, emit) {
      emit(
        state.copyWith(
          requestCount: 0,
          requestsCancelled: 0,
          requestsCompleted: 0,
        ),
      );
    });
  }
  final UserApiService userApiService;

  @override
  Future<void> close() {
    userApiService.cancelRequest(userApiService.cancelTokenTag);
    return super.close();
  }
}
