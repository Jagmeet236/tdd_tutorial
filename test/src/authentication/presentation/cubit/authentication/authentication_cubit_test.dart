import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_user.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication/authentication_cubit.dart';

class MockCreateUsers extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;
  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(
    message: 'Error',
    statusCode: 400,
  );
  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUsers();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });
  tearDown(() => cubit.close());

  test('initial state should be [AUthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group(
    'createUser',
    () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreated] when successful',
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
        expect: () => const [
          CreatingUser(),
          UserCreated(),
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser,'
        'AuthenticationError] when unsuccessful',
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Left(tAPIFailure),
          );
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
        expect: () => [
          const CreatingUser(),
          AuthenticationError(tAPIFailure.errorMessage)
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );
    },
  );
  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UserLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUsers(),
        UsersLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit'
      '[GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () =>
          [const GettingUsers(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
