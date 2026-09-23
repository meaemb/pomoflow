import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomoflow/components/login.dart';
import 'package:pomoflow/providers.dart';
import 'package:pomoflow/models/user_dao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockUserDao extends ChangeNotifier implements UserDao {
  @override
  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  String errorMsg = 'An error has occurred.';

  @override
  bool isLoggedIn() => false;

  @override
  String? email() => null;

  @override
  String? userId() => null;

  @override
  Future<String?> signup(String email, String password) async => null;

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<void> logout() async {}

  @override
  void dispose() {}
}

Widget _wrapWithProvider(Widget child) {
  return ProviderScope(
    overrides: [
      userDaoProvider.overrideWith((ref) => MockUserDao()),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  testWidgets('Login screen shows title', (tester) async {
    await tester.pumpWidget(_wrapWithProvider(const Login()));

    expect(find.text('PomoFlow'), findsOneWidget);
  });

  testWidgets('Login screen shows email and password fields', (tester) async {
    await tester.pumpWidget(_wrapWithProvider(const Login()));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create new account'), findsOneWidget);
  });
}