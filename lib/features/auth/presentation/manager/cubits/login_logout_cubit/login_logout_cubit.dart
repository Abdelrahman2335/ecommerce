import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_logout_state.dart';

class LoginLogoutCubit extends Cubit<LoginLogoutState> {
  LoginLogoutCubit() : super(LoginLogoutInitial());
}
