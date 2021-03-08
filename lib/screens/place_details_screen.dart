import 'package:flutter/material.dart';
import 'package:native_device_cide/helper/location_helper.dart';
import 'package:native_device_cide/provides/user_places.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = "/place-details-screen";

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;
    final userData = Provider.of<UserPlaces>(context, listen: false);
    final staticMapUrl = LocationHelper.getLocationPreviewImage(
      latitude: userData.items[index].location.latitude,
      longitude: userData.items[index].location.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Place"),
      ),
      body: Consumer<UserPlaces>(
        builder: (ctx, data, child) => Column(
          children: [
            Container(
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
            Container(
              child: Column(
                children: [
                  Text(
                    "${data.items[index].title}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 25,
                        color: Colors.blue,
                      ),
                      Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Image.network(
                      staticMapUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
