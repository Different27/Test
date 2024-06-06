// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthenticationState {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateSucces extends AuthenticationState {
  final User firebaseUser;
  const AuthenticationStateSucces({required this.firebaseUser});

  @override
  List<Object> get props => [firebaseUser];

  @override
  String toString() =>
      'AuthenticationStateSucces, email: ${firebaseUser.email}';
}

class AuthenticationStateFailure extends AuthenticationState {}
