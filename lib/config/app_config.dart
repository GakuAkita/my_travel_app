import 'dart:io';

/// アプリケーション設定
/// local.propertiesから管理者メールアドレスを読み込む
/// このファイルは.gitignoreに含まれているため、個人情報を安全に保存できます
class AppConfig {
  static List<String>? _adminEmails;

  /// local.propertiesから管理者メールアドレスを読み込む
  /// 実行時にはファイルが存在しない可能性があるため、空リストを返す可能性があります
  static List<String> _loadAdminEmails() {
    if (_adminEmails != null) {
      return _adminEmails!;
    }

    _adminEmails = <String>[];

    try {
      // android/local.propertiesから読み込む
      // 注意: 実行時にはファイルパスが異なる可能性があります
      final file = File('android/local.properties');
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.startsWith('admin.emails=')) {
            final emails = trimmed.substring('admin.emails='.length).trim();
            if (emails.isNotEmpty) {
              _adminEmails =
                  emails
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
              break;
            }
          }
        }
      }
    } catch (e) {
      // ファイルが存在しない、または読み込めない場合は空リスト
      // 本番環境では空リストになるため、個人情報が漏洩しません
    }

    return _adminEmails!;
  }

  /// 指定されたメールアドレスが管理者かどうかを判定
  static bool isAdminEmail(String email) {
    final adminEmails = _loadAdminEmails();
    return adminEmails.contains(email);
  }
}
