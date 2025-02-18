import 'package:delarship/Class/cars.dart';
import 'package:delarship/screens/home_page.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  HomePage a = const HomePage();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCLogic, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCLogic.get(context);
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(25))),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                    
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Exotic's Dealership",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  cubit.mess("Payment Available Only Offline");
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          Icons.wallet,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Payment',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          size: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            child: const Text(
                              'Add Car',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              cubit.mess('New Cars  Will Be Add Soon');
                              
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SlideAction(
                        submittedIcon: const Icon(
                          Icons.check_outlined,
                          color: Colors.green,
                        ),
                        borderRadius: 12,
                        innerColor: Colors.brown[100],
                        outerColor: Colors.black,
                        elevation: 1,
                        onSubmit: () {
                          cubit.sinout(context);
                          return null;
                        },
                        sliderButtonIcon: const Icon(Icons.power_settings_new_sharp),
                        text: 'Logout',
                        textStyle: TextStyle(
                            color: Colors.brown[100],
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
