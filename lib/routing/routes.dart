abstract final class Routes {
  static const start = "/start";
  static const signIn = "/sign_in";
  static const signUp = "/sign_up";
  static const itinerary = "/itinerary";
  static const expenses = "/expenses";
  static const settings = "/settings";

  //認証不要なルートのリスト
  static const publicRoutes = [start, signIn, signUp];
}
