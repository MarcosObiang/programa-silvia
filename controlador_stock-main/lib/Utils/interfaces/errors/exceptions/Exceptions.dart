import 'package:equatable/equatable.dart';

class MediaFileException extends Equatable implements Exception {
  String message;
  @override
  List<Object?> get props => [message, this];

  MediaFileException({required this.message});

  @override
  String toString() => message;
}

class ProductCreationException extends Equatable implements Exception {
  String message;
  @override
  List<Object?> get props => [message, this];

  ProductCreationException({required this.message});

  @override
  String toString() => message;
}

class GenericException extends Equatable implements Exception {
  String message;
  @override
  List<Object?> get props => [message, this];

  GenericException({required this.message});

  @override
  String toString() => message;
}

class NetworkException extends Equatable implements Exception {
  String message;
  @override
  List<Object?> get props => [message, this];

  NetworkException({required this.message});

  @override
  String toString() => message;
}
