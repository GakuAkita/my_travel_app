abstract class AppAuthCredential {}

// Emailとパスワードによる認証情報
class EmailAppCredential extends AppAuthCredential {
  final String email;
  final String password;

  EmailAppCredential({required this.email, required this.password});
}
