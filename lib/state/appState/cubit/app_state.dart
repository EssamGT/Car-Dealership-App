part of 'app_logic.dart';

@immutable
sealed class AppState {}
final class AppInitial extends AppState {}
final class Favpage extends AppState {}
final class AddToFire extends AppState {}
final class Ll extends AppState {}
final class Sinout extends AppState {}
final class DataLoading extends AppState {}
final class AddToFav extends AppState {}
final class RemoveFromFav extends AppState {}
final class AddtoFavfromsc extends AppState {}


