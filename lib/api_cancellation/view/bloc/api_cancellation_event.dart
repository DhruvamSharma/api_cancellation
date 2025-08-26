part of 'api_cancellation_bloc.dart';

@immutable
sealed class ApiCancellatioEvent extends Equatable {
  const ApiCancellatioEvent();

  @override
  List<Object> get props => [];
}

class StartManualApiRequest extends ApiCancellatioEvent {
  const StartManualApiRequest();
}

class CancelManualApiRquest extends ApiCancellatioEvent {
  const CancelManualApiRquest();
}

class ClearStats extends ApiCancellatioEvent {
  const ClearStats();
}
