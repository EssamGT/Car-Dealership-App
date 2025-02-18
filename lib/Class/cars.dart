

class Cars {

  List<String> images=[];
  int price;
  String description;
  String brandName;
  String model;
  int year;

  Cars(
      {required this.price,
    required this.description,
    required this.brandName,
    required this.model,
    required this.year,
      required this.images})
  ;




}

class CarModel {
  List<dynamic> images=[];
  String price;
  String description;
  String brandName;
  String model;
  int year;

  CarModel({
    required this.price,
    required this.description,
    required this.brandName,
    required this.model,
    required this.year,
    required this.images
  });

  // Convert CarModel object to JSON format (for API or storage purposes)
  // Map<String, dynamic> toJson() {
  //   return {
  //     'price': price??'',
  //     'email': email??'',
  //   };
  // }
  // Convert JSON to CarModel object (for reading from API or storage)
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      price: json['price']??'',
      description: json['description'],
      brandName: json['brandname'],
      model: json['model'],
      year: json['year'],
      images: json['imageUrl'],
    );
  }


@override
String toString() {
  return 'Car{price: $price,$runtimeType';
}
}
