import 'package:equatable/equatable.dart';
// T is type of data
sealed class DataField<T> extends Equatable {
  const DataField();
}

class DataFieldInitial<T> extends DataField<T> {
  const DataFieldInitial();
  @override
  List<Object?> get props => [];
}
class DataFieldLoading<T> extends DataField<T> {
  const DataFieldLoading();


  @override
  List<Object?> get props => [];
}
class DataFieldSuccess<T> extends DataField<T> {
  const DataFieldSuccess(this.data);
  final T data;

  @override
  List<Object?> get props => [data];
}

class DataFieldError<T> extends DataField<T> {
  const DataFieldError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
