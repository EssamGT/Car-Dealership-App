import 'package:delarship/screens/createAccount.dart';
import 'package:delarship/screens/forgetPass.dart';
import 'package:delarship/state/login_logic.dart';
import 'package:delarship/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String route = 'loginscreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginLogic(),
      child: BlocConsumer<LoginLogic, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          LoginLogic obj = BlocProvider.of(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SlideTransition(
                            position: _slideAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Image.asset('assets/images/logo.jpg'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.brown.shade100,
                                    Colors.brown.shade200,
                                    Colors.brown.shade300,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Form(
                                key: obj.fromKey,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          SlideTransition(
                                            position: _slideAnimation,
                                            child: TextFormField(
                                              controller: obj.email,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Email Cannot Be Empty';
                                                }
                                                if (value.length < 8) {
                                                  return 'Email Must Be At Least 8 Characters';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                hintText: 'Email',
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    strokeAlign: 30,
                                                    width: 3,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SlideTransition(
                                            position: _slideAnimation,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Password Cannot Be Empty';
                                                }
                                                if (value.length < 8) {
                                                  return 'Password Must Be At Least 8 Characters';
                                                }
                                                return null;
                                              },
                                              obscureText: obj.pass,
                                              controller: obj.password,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                hintText: 'Password',
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    strokeAlign: 30,
                                                    width: 3,
                                                  ),
                                                ),
                                                suffixIcon: obj.showpass(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          FadeTransition(
                                            opacity: _fadeAnimation,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(
                                                      Forgetpass.route);
                                                },
                                                child: const Text(
                                                  'Forgot Password?',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration:
                                                        TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ScaleTransition(
                                            scale: _scaleAnimation,
                                            child: MaterialButton(
                                              color: Colors.black,
                                              minWidth: double.infinity,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 45,
                                              onPressed: () {
                                                if (obj.fromKey.currentState!
                                                    .validate()) {
                                                  obj.login(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }
                                              },
                                              child: const Text(
                                                'Login',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          ScaleTransition(
                                            scale: _scaleAnimation,
                                            child: MaterialButton(
                                              color: Colors.white,
                                              minWidth: double.infinity,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 45,
                                              onPressed: () {
                                                obj.signInWithGoogle(context);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/google.jpg',
                                                    scale: 48,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Text(
                                                    'Login using Google',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          FadeTransition(
                                            opacity: _fadeAnimation,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                      "Don't Have an Account? "),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(Createaccount
                                                              .route);
                                                    },
                                                    child: const Text(
                                                      'Create Account',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        decoration: TextDecoration
                                                            .underline,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
