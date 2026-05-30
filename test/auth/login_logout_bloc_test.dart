import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/login_logout_repo/login_repo.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/login_logout_bloc/login_logout_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

class MockFirebaseService extends Mock implements FirebaseService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

void main() {
  late MockLoginRepository loginRepo;
  late MockFirebaseService firebaseService;
  late MockFirebaseAuth firebaseAuth;
  late LoginLogoutBloc bloc;
  late MockUser mockUser;

  setUp(() {
    loginRepo = MockLoginRepository();
    firebaseService = MockFirebaseService();
    firebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    when(() => firebaseService.auth).thenReturn(firebaseAuth);
    when(() => firebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');

    bloc = LoginLogoutBloc(loginRepo, firebaseService);
  });

  tearDown(() => bloc.close());

  group('LoginEmailChanged / LoginPasswordChanged', () {
    blocTest<LoginLogoutBloc, LoginLogoutState>(
      'emits updated email and initial status when LoginEmailChanged is added',
      build: () => bloc,
      act: (b) => b.add(const LoginEmailChanged('test@example.com')),
      expect: () => [
        isA<LoginLogoutState>()
            .having((s) => s.email, 'email', 'test@example.com')
            .having((s) => s.status, 'status', LoginStatus.initial),
      ],
    );

    blocTest<LoginLogoutBloc, LoginLogoutState>(
      'emits updated password and initial status when LoginPasswordChanged is added',
      build: () => bloc,
      act: (b) => b.add(const LoginPasswordChanged('password123')),
      expect: () => [
        isA<LoginLogoutState>()
            .having((s) => s.password, 'password', 'password123')
            .having((s) => s.status, 'status', LoginStatus.initial),
      ],
    );
  });

  group('LoginSubmitted', () {
    final mockUserCredential = MockUserCredential();
    final mockAdditionalInfo = MockAdditionalUserInfo();

    blocTest<LoginLogoutBloc, LoginLogoutState>(
      'emits [loading, success] on successful login',
      build: () {
        when(() => mockAdditionalInfo.isNewUser).thenReturn(false);
        when(() => mockUserCredential.additionalUserInfo).thenReturn(mockAdditionalInfo);
        when(() => loginRepo.loginWithEmail('password123', 'test@example.com'))
            .thenAnswer((_) async => Right(mockUserCredential));
        return bloc;
      },
      seed: () => const LoginLogoutState(email: 'test@example.com', password: 'password123'),
      act: (b) => b.add(LoginSubmitted()),
      expect: () => [
        isA<LoginLogoutState>().having((std) => std.status, 'status', LoginStatus.loading),
        isA<LoginLogoutState>()
            .having((std) => std.status, 'status', LoginStatus.success)
            .having((std) => std.userEmail, 'userEmail', 'test@example.com')
            .having((std) => std.isNewUser, 'isNewUser', false),
      ],
    );

    blocTest<LoginLogoutBloc, LoginLogoutState>(
      'emits [loading, error] on failure',
      build: () {
        when(() => loginRepo.loginWithEmail('wrongpass', 'test@example.com'))
            .thenAnswer((_) async => Left(FirebaseAuthFailure('user-not-found')));
        return bloc;
      },
      seed: () => const LoginLogoutState(email: 'test@example.com', password: 'wrongpass'),
      act: (b) => b.add(LoginSubmitted()),
      expect: () => [
        isA<LoginLogoutState>().having((std) => std.status, 'status', LoginStatus.loading),
        isA<LoginLogoutState>()
            .having((std) => std.status, 'status', LoginStatus.error)
            .having((std) => std.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );
  });

  group('LogoutRequested', () {
    blocTest<LoginLogoutBloc, LoginLogoutState>(
      'emits [loading, success] on successful logout',
      build: () {
        when(() => loginRepo.signOut()).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(LogoutRequested()),
      expect: () => [
        isA<LoginLogoutState>().having((std) => std.status, 'status', LoginStatus.loading),
        isA<LoginLogoutState>().having((std) => std.status, 'status', LoginStatus.success),
      ],
    );
  });
}
