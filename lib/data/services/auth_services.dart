import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider;

class AuthServices {
  final Dio dio;

  AuthServices(this.dio);

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return dio.post(
      '/api/Auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> refreshToken({required String refreshToken}) async {
    return dio.post('/api/Auth/refresh', data: {'refresh_token': refreshToken});
  }

  Future<Response> logout() async {
    return dio.post('/api/Auth/logout');
  }

  Future<Response> me() async {
    return dio.get('/api/Auth/me');
  }

  Future<String> retreiveGoogleToken() async {
    try {
      // First sign out user
      await GoogleSignIn().signOut().catchError((err, stacktrace) {
        // Ignore sign out errors
        debugPrint('Google sign out error: $err');
        return null;
      });

      await FirebaseAuth.instance.signOut().catchError((err, stacktrace) {
        // Ignore sign out errors
        debugPrint('Firebase sign out error: $err');
      });

      // Trigger the authentication flow
      final googleSignInAccount = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleSignInAuth = await googleSignInAccount?.authentication;

      // Create a new credential
      final oauthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth?.accessToken,
        idToken: googleSignInAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final firebaseUser = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );

      final token = firebaseUser.credential?.accessToken;

      if (token == null) throw Exception('Firebase access token is null');

      return token;
    } on FirebaseAuthException catch (err) {
      throw Exception('Google auth error: ${err.message}');
    }
  }

  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return dio.post(
      '/api/Auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }
}
