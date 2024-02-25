part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class CreatingUser extends AuthenticationState {
  const CreatingUser();
}

class GettingUser extends AuthenticationState {
  const GettingUser();
}

class UserCreated extends AuthenticationState {
  const UserCreated();
}

class UsersLoaded extends AuthenticationState {
  const UsersLoaded(this.users);

  final List<User> users;
  @override
  List<Object> get props => users.map((user) => user.id).toList();
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
