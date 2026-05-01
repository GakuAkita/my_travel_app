abstract class AppAuthCredential {}

// Emailとパスワードによる認証情報
class EmailAppCredential extends AppAuthCredential {
  final String email;
  final String password;

  EmailAppCredential({required this.email, required this.password});
}

// Google認証情報
class GoogleAppCredential extends AppAuthCredential {
  final String email;

  GoogleAppCredential({required this.email});
}
