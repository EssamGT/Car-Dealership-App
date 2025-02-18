import 'package:delarship/firebase_options.dart';
import 'package:delarship/screens/Login_screen.dart';
import 'package:delarship/screens/createAccount.dart';
import 'package:delarship/screens/forgetPass.dart';
import 'package:delarship/screens/main_home_screen.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });


  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AppCLogic(),
      ),
    ],
    child: const MyApp(),
  ),);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
      debugShowCheckedModeBanner: false,
    home: FirebaseAuth.instance.currentUser==null? const LoginScreen(): const HomeScreen(),


    routes: {
      LoginScreen.route : (context)=> const LoginScreen(),
      Createaccount.route : (context)=> const Createaccount(),
      Forgetpass.route : (context)=> const Forgetpass(),
      HomeScreen.route : (context)=> const HomeScreen(),
    },
    );
  }
}
