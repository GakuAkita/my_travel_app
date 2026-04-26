abstract final class Routes {
  static const start = "/start";
  static const signIn = "/sign_in";
  static const signUp = "/sign_up";
  static const itinerary = "/itinerary";
  static const expenses = "/expenses";
  static const settings = "/settings";

  static const itinerary_table_edit = "/itinerary_table_edit";
  static const expenses_add_edit = "/expenses_add_edit";
  static const expenses_result = "/expenses_result";
  static const settings_profile = "/settings_profile";
  static const settings_travel_select = "/settings_travel_select";
  static const settings_version_info = "/settings_version_info";
  static const settings_create_group = "/settings_create_group";
  static const settings_create_travel = "/settings_create_travel";

  //認証不要なルートのリスト
  static const publicRoutes = [start, signIn, signUp];
}
