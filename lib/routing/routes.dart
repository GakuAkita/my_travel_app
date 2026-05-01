abstract final class Routes {
  static const start = "/start";
  static const sign_in = "/sign_in";
  static const sign_up = "/sign_up";
  static const reset_password = "/reset_password";

  static const itinerary = "/itinerary";
  static const expenses = "/expenses";
  static const settings = "/settings";

  static const itinerary_table_edit = "/itinerary_table_edit";
  static const expenses_add_edit = "/expenses_add_edit";
  static const expenses_result = "/expenses_result";
  static const estimated_expense = "/estimated_expense";
  static const settings_profile = "/settings_profile";
  static const settings_travel_select = "/settings_travel_select";
  static const settings_version_info = "/settings_version_info";
  static const settings_create_group = "/settings_create_group";
  static const settings_create_travel = "/settings_create_travel";

  //認証不要なルートのリスト
  static const publicRoutes = [start, sign_in, sign_up, reset_password];
}
