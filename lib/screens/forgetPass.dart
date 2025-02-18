import 'package:delarship/state/login_logic.dart';
import 'package:delarship/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Forgetpass extends StatefulWidget {
  static const String route = 'forget';

  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          child: Image.asset('assets/images/logo.jpg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.brown.shade100,
                              Colors.brown.shade200,
                              Colors.brown.shade300
                            ]),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Form(
                              key: obj.fromKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Email Cannot Be Empty';
                                            }
                                            if (value.length < 8) {
                                              return 'Email Must Be At Least 8 Characters';
                                            }
                                            return null;
                                          },
                                          controller: obj.Femail,
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
                                        const SizedBox(height: 20),
                                        ScaleTransition(
                                          scale: _controller,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  obj.forgeot(context);
                                                }
                                              },
                                              child: const Text(
                                                'Send Email',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
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
                      ),
                    ],
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
