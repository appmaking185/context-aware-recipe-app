// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String error;
  final int statusCode;

  const Failure(this.error, {this.statusCode = 101});

  @override
  List<Object> get props => [error, statusCode];
}
