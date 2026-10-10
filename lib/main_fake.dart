import 'package:flutter/material.dart';
import 'package:my_travel_app/data/services/fake/fake_backend.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'main.dart';

/// Fakeモードで起動する(Firebaseもエミュレータも不要)
/// flutter run -t lib/main_fake.dart
///
/// demo@example.com でサインインした状態で始まる。(パスワードは全員 "password")
/// サインイン画面から始めたいときは FakeBackend.seeded(signedIn: false) にする。
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final fake = FakeBackend.seeded();
  runApp(MultiProvider(providers: appProviders(fake: fake), child: const MyApp()));
}
