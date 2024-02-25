import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  //Arrange
  const tModel = UserModel.empty();
  test('should be the subclass of [User] entity', () {
    //Act
    //nothing to act on

    //Assert
    expect(tModel, isA<User>());
  });
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;
  group(
    'fromMap',
    () {
      test('should return a [UserModel] with the right data', () {
        //Act
        final result = UserModel.fromMap(tMap);

        //Assert
        expect(result, equals(tModel));
      });
    },
  );
  group(
    'fromJson',
    () {
      test('should return a [UserModel] with the right data', () {
        //Act
        final result = UserModel.fromJson(tJson);

        //Assert
        expect(result, equals(tModel));
      });
    },
  );
  group(
    'toMap',
    () {
      test('should return a [Map] with the right data', () {
        //act
        final result = tModel.toMap();

        //Assert
        expect(result, equals(tMap));
      });
    },
  );
  group(
    'toJson',
    () {
      test('should return a [Map] with the right data', () {
        // Act
        final result = tModel.toJson();
        final tJson = jsonEncode({
          "id": "1",
          "avatar": "_empty.avatar",
          "createdAt": "_empty.createdAt",
          "name": "_empty.name"
        });

        //Assert
        expect(result, tJson);
      });
      group('copyWith', () {
        test('should return a [UserModel] with different data', () {
          //Act
          final result = tModel.copyWith(name: 'Jagmeet');

          //Assert
          expect(result.name, equals('Jagmeet'));
        });
      });
    },
  );
}
