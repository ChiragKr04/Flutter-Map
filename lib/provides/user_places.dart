import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:native_device_cide/helper/db_helper.dart';
import 'package:native_device_cide/models/place.dart';

class UserPlaces with ChangeNotifier {
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }

  void addPlace(File image, String title, PlaceLocation loc) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: loc,
    );
    _items.add(newPlace);
    notifyListeners();
    DbHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": loc.latitude,
      "loc_lng": loc.longitude,
    });
  }

  Future<void> fetchPlaces() async {
    final dataList = await DbHelper.getData('user_places');
    _items = dataList
        .map((e) => Place(
              id: e['id'],
              image: File(e['image']),
              title: e['title'],
              location: PlaceLocation(
                latitude: e["loc_lat"],
                longitude: e["loc_lng"],
                address: "",
              ),
            ))
        .toList();
    print(dataList.toString());
    notifyListeners();
  }
}
