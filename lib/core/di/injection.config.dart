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

import '../../features/address/data/repo/AddressRepo.dart' as _i736;
import '../../features/address/data/repo/addressRepoImpl.dart' as _i510;
import '../../features/address/presentation/manager/address_bloc.dart' as _i244;
import '../../features/auth/data/auth_repo/create_user_repo/create_user_repo.dart'
    as _i237;
import '../../features/auth/data/auth_repo/create_user_repo/create_user_repo_impl.dart'
    as _i131;
import '../../features/auth/data/auth_repo/login_logout_repo/login_repo.dart'
    as _i570;
import '../../features/auth/data/auth_repo/login_logout_repo/login_repo_impl.dart'
    as _i582;
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
import '../../features/cart/data/repository/cart_repository.dart' as _i323;
import '../../features/cart/data/repository/cart_repository_impl.dart'
    as _i1063;
import '../../features/cart/presentation/manager/cart_bloc.dart' as _i474;
import '../../features/checkout/data/repository/checkout_repository.dart'
    as _i555;
import '../../features/checkout/data/repository/checkout_repository_impl.dart'
    as _i763;
import '../../features/checkout/presentation/manager/checkout_bloc.dart'
    as _i95;
import '../../features/home/data/repository/home_repo.dart' as _i930;
import '../../features/home/data/repository/home_repo_impl.dart' as _i1013;
import '../../features/home/presentation/manager/home_bloc.dart' as _i801;
import '../../features/wishlist/data/repository/wishlist_repository.dart'
    as _i410;
import '../../features/wishlist/data/repository/wishlist_repository_impl.dart'
    as _i669;
import '../../features/wishlist/presentation/manager/wishlist_bloc.dart'
    as _i17;
import '../network/api_config.dart' as _i995;
import '../network/api_service.dart' as _i921;
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
    gh.lazySingleton<_i995.ApiConfig>(() => _i995.ApiConfig.create());
    gh.lazySingleton<_i758.FirebaseService>(() => _i758.FirebaseService());
    gh.lazySingleton<_i921.ApiService>(
        () => _i921.ApiService(gh<_i995.ApiConfig>()));
    gh.lazySingleton<_i930.HomeRepo>(
        () => _i1013.HomeRepoImpl(gh<_i921.ApiService>()));
    gh.lazySingleton<_i410.WishListRepository>(
        () => _i669.WishListRepositoryImpl(gh<_i758.FirebaseService>()));
    gh.lazySingleton<_i555.CheckoutRepository>(
        () => _i763.CheckoutRepositoryImpl());
    gh.factory<_i570.LoginRepository>(
        () => _i582.LoginRepositoryImpl(gh<_i758.FirebaseService>()));
    gh.factory<_i237.SignupRepository>(
        () => _i131.SignupRepositoryImpl(gh<_i758.FirebaseService>()));
    gh.factory<_i801.HomeBloc>(() => _i801.HomeBloc(gh<_i930.HomeRepo>()));
    gh.lazySingleton<_i323.CartRepository>(
        () => _i1063.CartRepositoryImpl(gh<_i758.FirebaseService>()));
    gh.factory<_i699.SignupBloc>(() => _i699.SignupBloc(
          gh<_i237.SignupRepository>(),
          gh<_i758.FirebaseService>(),
        ));
    gh.lazySingleton<_i736.AddressRepo>(() => _i510.AddressRepoImpl(
          gh<_i758.FirebaseService>(),
          gh<_i921.ApiService>(),
        ));
    gh.factory<_i85.LoginLogoutBloc>(() => _i85.LoginLogoutBloc(
          gh<_i570.LoginRepository>(),
          gh<_i758.FirebaseService>(),
        ));
    gh.factory<_i474.CartBloc>(
        () => _i474.CartBloc(gh<_i323.CartRepository>()));
    gh.lazySingleton<_i499.UserRegistrationRepo>(
        () => _i763.UserRegistrationRepoImpl(gh<_i758.FirebaseService>()));
    gh.factory<_i17.WishlistBloc>(
        () => _i17.WishlistBloc(gh<_i410.WishListRepository>()));
    gh.factory<_i710.UserRegistrationBloc>(
        () => _i710.UserRegistrationBloc(gh<_i499.UserRegistrationRepo>()));
    gh.factory<_i244.AddressBloc>(
        () => _i244.AddressBloc(gh<_i736.AddressRepo>()));
    gh.factory<_i95.CheckoutBloc>(() => _i95.CheckoutBloc(
          gh<_i555.CheckoutRepository>(),
          gh<_i736.AddressRepo>(),
          gh<_i474.CartBloc>(),
        ));
    return this;
  }
}
