enum SCREEN_TYPE { LOGIN, SIGNUP }

enum FUNC_RESULT {
  SUCCESS,
  ERROR,
  INVALID_EMAIL,
  WEAK_PASSWORD,
  EMAIL_ALREADY_IN_USE,
  USER_NOT_FOUND,
  WRONG_PASSWORD,
  USER_DISABLED,
  TOO_MANY_REQUESTS,
  OPERATION_NOT_ALLOWED,
}

/**
 *　ユーザーの役割を保持。
 */
class UserRole {
  static const normal = 'normal';
  static const admin = 'admin';
}

/**
 * Itineraryのコンテンツタイプ
 */
class ItinerarySectionType {
  static const markdown = "markdown";
  static const defaultTable = "default_table";
  static const checkBox = "checkBox";
  static const space = "space";
}
