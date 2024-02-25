import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repository/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

//Test-Driven Development
// call the remote data source
//check if the method returns the proper data
//make sure that it returns the proper data if there is no exception
// check if when the remoteDataSource throws an exception,we return
// a failure and if it doesn't throw an exception, we return the actual
// expected data

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });
  const tException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );
  const createdAt = 'whatever.createdAt';
  const name = 'whatever.name';
  const avatar = 'whatever.avatar';
  group('createUser', () {
    test(
      'should call the [RemoteDataSource.createUser] and complete successfully'
      ' when the call to the remote source is successful',
      () async {
        // arrange
        when(
          () => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repoImpl.createUser(
            createdAt: createdAt, name: name, avatar: avatar);

        // assert
        expect(result, equals(const Right(null)));
        verify(() => remoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [ServerFailure] when the call to the remote'
      'source is unsuccessful',
      () async {
        //Arrange
        when(
          () => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')),
        ).thenThrow(tException);

        // act
        final result = await repoImpl.createUser(
            createdAt: createdAt, name: name, avatar: avatar);

        expect(
          result,
          equals(
            Left(
              APIFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );
        verify(() => remoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group(
    'getUsers',
    () {
      test(
        'should call the [RemoteDataSource.getUser] and return [List<User>]'
        'when the call to the remote source is successful',
        () async {
          //Arrange
          when(
            () => remoteDataSource.getUser(),
          ).thenAnswer((_) async => []);

          //act
          final result = await repoImpl.getUser();

          //assert
          expect(
            result,
            isA<Right<dynamic, List<User>>>(),
          );
          verify(() => remoteDataSource.getUser()).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
          'should return a [ServerFailure] when the call to the remote'
          'source is unsuccessful', () async {
        //Arrange
        when(
          () => remoteDataSource.getUser(),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.getUser();

        //assert
        expect(
          result,
          equals(
            Left(
              APIFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );
        verify(() => remoteDataSource.getUser()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      });
    },
  );
}
