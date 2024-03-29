import 'package:mynotes/Services/auth/auth_provider.dart';
import 'package:mynotes/Services/auth/auth_user.dart';

class AuthService extends AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  @override
  Future<AuthUser> creatUser({
    required String email,
    required String password,
  }) =>
      provider.creatUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
