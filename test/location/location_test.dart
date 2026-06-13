// address_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/address/data/repo/address_repo.dart';
import 'package:ecommerce/features/address/presentation/manager/address_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockAddressRepo extends Mock implements AddressRepo {}

void main() {
  late MockAddressRepo repo;

  setUp(() {
    repo = MockAddressRepo();
    // Default stub: constructor's LoadAddressEvent completes without data.
    when(() => repo.getUserAddress())
        .thenAnswer((_) async => const Right(null));
  });

  group('LoadAddressEvent', () {
    final address = AddressModel(
      city: 'Cairo',
      area: 'Maadi',
      street: 'Street 9',
      latitude: 30.05,
      longitude: 31.23,
    );

    blocTest<AddressBloc, AddressState>(
      'emits [loading, success] with address and userLocation on success',
      build: () {
        when(() => repo.getUserAddress())
            .thenAnswer((_) async => Right(address));
        return AddressBloc(repo);
      },
      expect: () => [
        const AddressState(status: AddressStatus.loading),
        AddressState(
          status: AddressStatus.success,
          currentAddress: address,
          userLocation: LatLng(30.05, 31.23),
        ),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'emits [loading, error] on failure',
      build: () {
        when(() => repo.getUserAddress())
            .thenAnswer((_) async => Left(FirestoreFailure("Network error")));
        return AddressBloc(repo);
      },
      expect: () => [
        const AddressState(status: AddressStatus.loading),
        isA<AddressState>()
            .having((s) => s.status, 'status', AddressStatus.error)
            .having((s) => s.errMessage, 'errMessage', isNotEmpty),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'emits success with no location when address has null coords',
      build: () {
        when(() => repo.getUserAddress()).thenAnswer(
          (_) async => Right(AddressModel(city: 'Cairo')),
        );
        return AddressBloc(repo);
      },
      expect: () => [
        const AddressState(status: AddressStatus.loading),
        isA<AddressState>()
            .having((s) => s.status, 'status', AddressStatus.success)
            .having((s) => s.userLocation, 'userLocation', isNull),
      ],
    );
  });

  group('SaveAddressEvent', () {
    final address =
        AddressModel(city: 'Cairo', area: 'Dokki', street: 'Test St');

    blocTest<AddressBloc, AddressState>(
      'emits [loading, success] and updates currentAddress',
      build: () {
        when(() => repo.updateAddressDetails(address))
            .thenAnswer((_) async => const Right(null));
        return AddressBloc(repo);
      },
      act: (b) => b.add(SaveAddressEvent(address)),
      skip: 2, // skip: LoadAddressEvent → loading + success(null)
      expect: () => [
        const AddressState(status: AddressStatus.loading),
        AddressState(status: AddressStatus.success, currentAddress: address),
      ],
    );
  });

  group('DeleteAddressEvent', () {
    blocTest<AddressBloc, AddressState>(
      'emits success with null address',
      build: () {
        when(() => repo.getUserAddress()).thenAnswer(
          (_) async => Right(AddressModel(city: 'Cairo')),
        );
        when(() => repo.deleteUserAddress())
            .thenAnswer((_) async => const Right(null));
        return AddressBloc(repo);
      },
      act: (b) => b.add(DeleteAddressEvent()),
      skip: 2, // skip: LoadAddressEvent → loading + success(existing address)
      expect: () => [
        isA<AddressState>()
            .having((s) => s.status, 'status', AddressStatus.loading),
        isA<AddressState>()
            .having((s) => s.currentAddress, 'currentAddress', isNull)
            .having((s) => s.status, 'status', AddressStatus.success),
      ],
    );
  });
}
