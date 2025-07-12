// core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Define as final immutable list
  final List<dynamic> properties;

  // Make constructor properly handle constant values
  const Failure([this.properties = const []]);

  @override
  List<Object?> get props => [properties];
}

class DatabaseFailure extends Failure {
  final String message;

  // Use const constructor correctly
  const DatabaseFailure(this.message) : super(const []);

  // Override props to directly include the message
  @override
  List<Object?> get props => [message];
}

// You can add more failure types if needed
class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure(this.message) : super(const []);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message) : super(const []);

  @override
  List<Object?> get props => [message];
}