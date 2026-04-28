import 'package:dartz/dartz.dart';

import 'app_type_def.dart';
import 'failure.dart';

mixin UpdateUiMixin {
  Future<Either<Failure, T>> backToUI<T>(ManageAPIResponse manageAPIResponse, {dynamic flag});
}
