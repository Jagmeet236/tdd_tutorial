import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

import 'package:tdd_tutorial/src/authentication/domain/usecases/get_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;
  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = GetUsers(repository);
  });
  final tResponse = [const User.empty()];
  test(
    'should call [AuthenticationRepository.getUsers] and return ',
    () async {
      //Arrange
      when(() => repository.getUser()).thenAnswer(
        (_) async => Right(tResponse),
      );

      //Act
      final result = await usecase();

      //Assert
      expect(result, equals(Right<dynamic, List<User>>(tResponse)));
      verify(() => repository.getUser()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
