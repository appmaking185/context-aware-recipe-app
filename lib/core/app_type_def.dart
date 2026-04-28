import 'package:dartz/dartz.dart';

import 'failure.dart';

typedef ManageAPIResponse<T> = Future<Either<Failure, T>> Function();
