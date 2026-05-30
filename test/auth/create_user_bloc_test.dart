import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/create_user_repo/create_user_repo.dart';
import 'package:ecommerce/features/auth/presentation/manager/cubits/create_user_bloc/create_user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignupRepository extends Mock implements SignupRepository {}

class MockFirebaseService extends Mock implements FirebaseService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

void main() {
  late MockSignupRepository signupRepo;
  late MockFirebaseService firebaseService;
  late MockFirebaseAuth firebaseAuth;
  late SignupBloc bloc;
  late MockUser mockUser;

  setUp(() {
    signupRepo = MockSignupRepository();
    firebaseService = MockFirebaseService();
    firebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    when(() => firebaseService.auth).thenReturn(firebaseAuth);
    when(() => firebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.email).thenReturn('new@example.com');
    when(() => mockUser.displayName).thenReturn('New User');

    bloc = SignupBloc(signupRepo, firebaseService);
  });

  tearDown(() => bloc.close());

  group('Form Validation Events', () {
    blocTest<SignupBloc, SignupBlocState>(
      'validates to true when all fields are correct',
      build: () => bloc,
      seed: () => const SignupBlocState(
          password: 'password123', confirmPassword: 'password123'),
      act: (b) => b.add(const SignupEmailChanged('new@example.com')),
      expect: () => [
        isA<SignupBlocState>()
            .having((s) => s.email, 'email', 'new@example.com')
            .having((s) => s.isValid, 'isValid', true),
      ],
    );
  });

  group('SignupSubmitted', () {
    final mockUserCredential = MockUserCredential();
    final mockAdditionalInfo = MockAdditionalUserInfo();

    blocTest<SignupBloc, SignupBlocState>(
      'emits error if passwords mismatched',
      build: () => bloc,
      seed: () => const SignupBlocState(
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'different',
        isValid: true,
      ),
      act: (b) => b.add(SignupSubmitted()),
      expect: () => [
        isA<SignupBlocState>()
            .having((s) => s.status, 'status', SignupStatus.error)
            .having(
                (s) => s.errorMessage, 'errorMessage', 'Password not match'),
      ],
    );

    blocTest<SignupBloc, SignupBlocState>(
      'emits [loading, success] on successful signup',
      build: () {
        when(() => mockAdditionalInfo.isNewUser).thenReturn(true);
        when(() => mockUserCredential.additionalUserInfo)
            .thenReturn(mockAdditionalInfo);
        when(() => signupRepo.createUserWithEmailAndPassword(
                'new@example.com', 'password123'))
            .thenAnswer((_) async => Right(mockUserCredential));
        return bloc;
      },
      seed: () => const SignupBlocState(
        email: 'new@example.com',
        password: 'password123',
        confirmPassword: 'password123',
        isValid: true,
      ),
      act: (b) => b.add(SignupSubmitted()),
      expect: () => [
        isA<SignupBlocState>()
            .having((std) => std.status, 'status', SignupStatus.loading),
        isA<SignupBlocState>()
            .having((std) => std.status, 'status', SignupStatus.success)
            .having((std) => std.userEmail, 'userEmail', 'new@example.com')
            .having((std) => std.isNewUser, 'isNewUser', true),
      ],
    );
  });
}
