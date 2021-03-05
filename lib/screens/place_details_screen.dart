import 'package:flutter/material.dart';
import 'package:native_device_cide/provides/user_places.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = "/place-details-screen";

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text("Place"),
      ),
      body: Consumer<UserPlaces>(
        builder: (ctx, data, child) => Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(5),
          height: 300,
          width: double.infinity,
          child: Hero(
            tag: data.items[index].id,
            child: Image.file(
              data.items[index].image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
