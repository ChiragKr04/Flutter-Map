import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:native_device_cide/provides/user_places.dart';
import 'package:native_device_cide/screens/add_place_screen.dart';
import 'package:native_device_cide/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatefulWidget {
  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  void _getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print(_locationData);
  }

  @override
  // void initState() {
  //   _getLocation();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    _getLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddPlaceScreen.routeName,
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _getLocation();
          return Provider.of<UserPlaces>(context, listen: false).fetchPlaces();
        },
        child: FutureBuilder(
          future: Provider.of<UserPlaces>(context, listen: false).fetchPlaces(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<UserPlaces>(
                  child: Center(
                    child: Text(
                      "No Places added yet!\n Add some!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  builder: (ctx, userPlace, ch) => userPlace.items.length <= 0
                      ? ch
                      : ListView.builder(
                          itemCount: userPlace.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                "${userPlace.items[index].title}",
                              ),
                              subtitle: Text(
                                "${userPlace.items[index].location.latitude.toStringAsFixed(5)}, ${userPlace.items[index].location.longitude.toStringAsFixed(5)}",
                              ),
                              leading: Hero(
                                tag: userPlace.items[index].id,
                                child: CircleAvatar(
                                  backgroundImage: FileImage(
                                    userPlace.items[index].image,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailsScreen.routeName,
                                  arguments: index,
                                );
                              },
                            );
                          },
                        ),
                ),
        ),
      ),
    );
  }
}
