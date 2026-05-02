import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository.dart';

class GoogleAuthRepositoryFirebase implements GoogleAuthRepository {
  final FirebaseAuth _firebaseAuth;

  GoogleAuthRepositoryFirebase({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> signIn() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _firebaseAuth.signInWithPopup(googleProvider);
      } else if (Platform.isAndroid) {
        //https://github.com/flutter/flutter/issues/172073
        final GoogleSignIn googleSignIn = GoogleSignIn.instance;
        await googleSignIn.initialize(); /* 最初にinitializeをしないとだめ。 */

        final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

        /* 明示的にリンクしなくても、勝手にリンクしてくれるらしい */
        await _firebaseAuth.signInWithCredential(credential);
      } else {
        throw AppException("Not implemented yet");
      }
    } on GoogleSignInException catch (e) {
      throw AppException(e.description ?? "Unknown", code: e.code.toString());
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
