import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuth {
  String? verificationId;

  Future<void> sendOtp({required String phone}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,

      /// OTP sent
      codeSent: (String vId, int? resendToken) {
        verificationId = vId;
      },

      /// Auto verification (sometimes)
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },

      /// Error
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },

      /// Timeout
      codeAutoRetrievalTimeout: (String vId) {
        verificationId = vId;
      },
    );
  }

  Future<bool> verifyOtp(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        return false;
        // TODO
      }
    }
    return true;
  }

  Future<void> resendOtp(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,

      codeSent: (String vId, int? resendToken) {
        verificationId = vId; // 🔥 replace old one
      },

      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },

      verificationFailed: (e) {
        print(e.message);
      },

      codeAutoRetrievalTimeout: (vId) {
        verificationId = vId;
      },
    );
  }
}
