// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/auth_repo/create_user_repo/create_user_repo.dart'
    as _i237;
import '../../features/auth/data/auth_repo/create_user_repo/create_user_repo_impl.dart'
    as _i131;
import '../../features/auth/data/auth_repo/login_logout_repo/repo.dart' as _i1;
import '../../features/auth/data/auth_repo/login_logout_repo/repo_impl.dart'
    as _i622;
import '../../features/auth/data/user_registration_repo/user_registration_repo.dart'
    as _i499;
import '../../features/auth/data/user_registration_repo/user_registration_repo_impl.dart'
    as _i763;
import '../../features/auth/presentation/manager/cubits/create_user_bloc/create_user_bloc.dart'
    as _i699;
import '../../features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart'
    as _i85;
import '../../features/auth/presentation/manager/cubits/user_registration/user_registration_bloc.dart'
    as _i710;
import '../services/firebase_service.dart' as _i758;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i758.FirebaseService>(() => _i758.FirebaseService());
    gh.factory<_i237.SignupRepository>(() => _i131.SignupRepositoryImpl());
    gh.factory<_i1.LoginRepository>(() => _i622.LoginRepositoryImpl());
    gh.factory<_i699.SignupBloc>(() => _i699.SignupBloc(
          gh<_i237.SignupRepository>(),
          gh<_i758.FirebaseService>(),
        ));
    gh.lazySingleton<_i499.UserRegistrationRepo>(
        () => _i763.UserRegistrationRepoImpl(gh<_i758.FirebaseService>()));
    gh.factory<_i85.LoginLogoutBloc>(() => _i85.LoginLogoutBloc(
          gh<_i1.LoginRepository>(),
          gh<_i758.FirebaseService>(),
        ));
    gh.factory<_i710.UserRegistrationBloc>(
        () => _i710.UserRegistrationBloc(gh<_i499.UserRegistrationRepo>()));
    return this;
  }
}
