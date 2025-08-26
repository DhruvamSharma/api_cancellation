import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
  });


  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
