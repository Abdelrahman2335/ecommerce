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
import '../../features/auth/presentation/manager/cubits/create_user_cubit/create_user_cubit.dart'
    as _i279;
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
    gh.factory<_i279.SignupCubit>(() => _i279.SignupCubit(
          gh<_i237.SignupRepository>(),
          gh<_i758.FirebaseService>(),
        ));
    return this;
  }
}
