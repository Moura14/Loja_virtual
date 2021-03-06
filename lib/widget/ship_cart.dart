import 'package:flutter/material.dart';

class ShipCart extends StatelessWidget {
  const ShipCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calcular frete",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[500]),
        ),
        leading: Icon(Icons.location_on),
        children: [
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Digite seu CEP"),
            initialValue: "",
            onFieldSubmitted: (text) {},
          )
        ],
      ),
    );
  }
}
