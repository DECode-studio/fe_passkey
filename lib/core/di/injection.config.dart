// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i9;
import 'package:fe_passkey/core/di/register_module.dart' as _i18;
import 'package:fe_passkey/core/network/dio_client.dart' as _i8;
import 'package:fe_passkey/core/storage/token_storage.dart' as _i7;
import 'package:fe_passkey/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i10;
import 'package:fe_passkey/features/auth/data/datasources/passkey_datasource.dart'
    as _i5;
import 'package:fe_passkey/features/auth/data/datasources/passkey_datasource_impl.dart'
    as _i6;
import 'package:fe_passkey/features/auth/data/repositories/auth_repository_impl.dart'
    as _i12;
import 'package:fe_passkey/features/auth/domain/repositories/auth_repository.dart'
    as _i11;
import 'package:fe_passkey/features/auth/domain/usecases/check_passkey_support.dart'
    as _i13;
import 'package:fe_passkey/features/auth/domain/usecases/login_with_passkey.dart'
    as _i14;
import 'package:fe_passkey/features/auth/domain/usecases/logout.dart' as _i15;
import 'package:fe_passkey/features/auth/domain/usecases/register_with_passkey.dart'
    as _i16;
import 'package:fe_passkey/features/auth/presentation/bloc/auth_bloc.dart'
    as _i17;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:passkeys/authenticator.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i4.PasskeyAuthenticator>(
        () => registerModule.passkeyAuthenticator);
    gh.lazySingleton<_i5.PasskeyDatasource>(
        () => _i6.PasskeyDatasourceImpl(gh<_i4.PasskeyAuthenticator>()));
    gh.lazySingleton<_i7.TokenStorage>(
        () => registerModule.tokenStorage(gh<_i3.FlutterSecureStorage>()));
    gh.lazySingleton<_i8.DioClient>(
        () => registerModule.dioClient(gh<_i7.TokenStorage>()));
    gh.lazySingleton<_i9.Dio>(() => registerModule.dio(gh<_i8.DioClient>()));
    gh.factory<_i10.AuthRemoteDatasource>(
        () => _i10.AuthRemoteDatasource(gh<_i9.Dio>()));
    gh.lazySingleton<_i11.AuthRepository>(() => _i12.AuthRepositoryImpl(
          remoteDatasource: gh<_i10.AuthRemoteDatasource>(),
          passkeyDatasource: gh<_i5.PasskeyDatasource>(),
          tokenStorage: gh<_i7.TokenStorage>(),
        ));
    gh.lazySingleton<_i13.CheckPasskeySupport>(
        () => _i13.CheckPasskeySupport(gh<_i11.AuthRepository>()));
    gh.factory<_i14.LoginWithPasskey>(
        () => _i14.LoginWithPasskey(gh<_i11.AuthRepository>()));
    gh.factory<_i15.Logout>(() => _i15.Logout(gh<_i11.AuthRepository>()));
    gh.factory<_i16.RegisterWithPasskey>(
        () => _i16.RegisterWithPasskey(gh<_i11.AuthRepository>()));
    gh.factory<_i17.AuthBloc>(() => _i17.AuthBloc(
          registerWithPasskey: gh<_i16.RegisterWithPasskey>(),
          loginWithPasskey: gh<_i14.LoginWithPasskey>(),
          logout: gh<_i15.Logout>(),
          checkPasskeySupport: gh<_i13.CheckPasskeySupport>(),
          tokenStorage: gh<_i7.TokenStorage>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i18.RegisterModule {}
