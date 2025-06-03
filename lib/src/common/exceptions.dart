import 'package:equatable/equatable.dart';

class RepositoryException extends Equatable implements Exception {
  final String message;

  const RepositoryException({required this.message});

  @override
  List<Object?> get props => [message];
}
