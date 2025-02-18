import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delarship/Class/cars.dart';
import 'package:delarship/List/carlist.dart';
import 'package:delarship/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'app_state.dart';

class AppCLogic extends Cubit<AppState> {
  AppCLogic() : super(AppInitial());
  static AppCLogic get(context) => BlocProvider.of(context);

  Carlist clist = Carlist();
  List data = [];
  List<int> activeIndices = [];
  CollectionReference carData = FirebaseFirestore.instance.collection('Car');

  Future<void> addToFire(
      {required String brandName,
      required String model,
      required int year,
      required List<String> imageUrl,
      required String price,
      required String description}) {
    return carData.add({
      'brandname': brandName, 
      'model': model, 
      'year': year,
      'imageUrl': imageUrl,
      'description': description,
      'price': price
    }).then((value) {
      print("User Added");
      emit(AddToFire());
    }).catchError((error) => print("Failed to add user: $error"));
  }

  List<CarModel> _carsList = [];
  final List<CarModel> _FavList = [];

  List<CarModel> get carsList => _carsList;
  List<CarModel> get favList => _FavList;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getCars() async {
    try {
      emit(DataLoading());
      QuerySnapshot snapshot = await _firestore.collection('Car').get();
      // Map the fetched data to a list of SchoolsModel
      _carsList = snapshot.docs.map((doc) {
        return CarModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      print('Total documents: ${data.length}');
      print('Data fetched successfully');
      emit(Ll()); 
    } catch (e) {
      print("Error fetching cars: $e");
    }
  }

  Future<void> li(List data) async {
    emit(DataLoading());
    await FirebaseFirestore.instance
        .collection('Car')
        .get()
        .then((QuerySnapshot querySnapshot) {
      
      for (var doc in querySnapshot.docs) {
        data.add(doc.data()); 
      }

      print('Total documents: ${data.length}');
      print('Data fetched successfully');
    }).catchError((error) {
      print('Error fetching data: $error');
    });

    emit(Ll()); 
  }



  sinout(context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    emit(Sinout());
  }

  addToFav(int i) {
    if (!favList.contains(carsList[i])) {
      favList.add(carsList[i]);
    } else {
      favList.remove(carsList[i]);
    }
    emit(AddToFav());
  }

  removefromFav(int i) {
    favList.removeAt(i);

    emit(RemoveFromFav());
  }
  addtoFavfromsc(int i,List shresult) {
    if (!favList.contains(shresult[i])) {
      favList.add(shresult[i]);
    } else {
      favList.remove(shresult[i]);
    }

    emit(AddtoFavfromsc());
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
