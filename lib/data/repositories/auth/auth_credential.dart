// Emailとパスワードによる認証情報
class EmailAppCredential {
  final String email;
  final String password;

  EmailAppCredential({required this.email, required this.password});
}

// Google認証情報
class GoogleAppCredential {
  final String email;

  GoogleAppCredential({required this.email});
}
