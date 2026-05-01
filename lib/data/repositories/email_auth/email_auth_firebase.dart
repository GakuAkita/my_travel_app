abstract class EmailAuthFirebase {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> sendResetPassword(String email);
}
