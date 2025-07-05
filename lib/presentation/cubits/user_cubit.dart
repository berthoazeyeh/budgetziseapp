import 'package:budget_zise/domain/models/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedCubit;

class AuthCubit extends HydratedCubit<UserModel?> {
  AuthCubit() : super(null);

  void setUser(UserModel value) => emit(value);

  void clearUser() => emit(null);

  bool get isSignedIn => state != null;

  UserModel get getSignedInUser => state!;

  @override
  UserModel? fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserModel? state) => state?.toJson();
}
