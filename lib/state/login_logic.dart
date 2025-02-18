import 'package:bloc/bloc.dart';
import 'package:delarship/screens/Login_screen.dart';
import 'package:delarship/screens/main_home_screen.dart';
import 'package:delarship/state/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginLogic extends Cubit<LoginState> {
  LoginLogic() : super(IniLog());
  GlobalKey<FormState> fromKey = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Femail = TextEditingController();

  TextEditingController Nemail = TextEditingController();
  TextEditingController Npassword = TextEditingController();
  bool islodin = false;
  bool pass = true;

  login(context) async {
    islodin = true;
    emit(Loding());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } on FirebaseAuthException catch (e) {
      print('#############${e.code}##############');
      islodin = false;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        mess('Wrong Password Or Email Address');
        print('Wrong Password.');
      }
    }
    emit(Login());
  }

  sinup(context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Nemail.text.trim(),
        password: Npassword.text.trim(),
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } on FirebaseAuthException catch (e) {
      print('############################ ${e.code}######################');
      if (e.code == 'weak-password') {
        mess('The password provided is too weak');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        mess('Email is already in use ');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    emit(CreatAcc());
  }

  sinout(context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    emit(Sinout());
  }

  Future signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    emit(Glogin());
  }

  Future forgeot(context) async {
    try {
      final credential = await FirebaseAuth.instance
          .sendPasswordResetEmail(email: Femail.text.trim());
      mess('Check Mail Box');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('33333333333333333333');
      print("################## ${e.code}##################");
      if (e.code == 'invalid-email') {
        mess('Invalid Email');
      }
    }
    emit(Forgot());
  }

  Widget showpass() {
    return IconButton(
        onPressed: () {
          pass = !pass;
          emit(Showpassword());
        },
        icon: pass ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility));
  }

  mess(String mass) {
    Fluttertoast.showToast(
        gravity: ToastGravity.NONE,
        msg: mass,
        textColor: Colors.black,
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT);
  }
}
