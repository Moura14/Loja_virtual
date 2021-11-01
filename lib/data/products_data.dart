import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String Id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    Id = snapshot.documentID;
    title = snapshot.data['title'];
    description = snapshot.data["description"];
    price = snapshot.data['price'];
    images = snapshot.data["images"];
    sizes = snapshot.data['sizes'];
  }

  Map<String, dynamic> resumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
