import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createdUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }
  final CreateUser _createUser;
  final GetUsers _getUsers;
  FutureOr<void> _createdUserHandler(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const CreatingUser());
    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));
    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (r) => emit(
        const UserCreated(),
      ),
    );
  }

  FutureOr<void> _getUsersHandler(
      GetUsersEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingUser());
    final result = await _getUsers();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(
        UsersLoaded(users),
      ),
    );
  }
}
