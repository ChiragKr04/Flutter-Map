import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as lc;

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;

  MapScreen(this.initialLocation);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  bool defaultMarker = true;
  LatLng defaultCords;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<LatLng> _getLocation() async {
    final locationData = await lc.Location().getLocation();
    defaultCords = LatLng(locationData.latitude, locationData.longitude);
    return defaultCords;
  }

  @override
  void didChangeDependencies() {
    _getLocation();
    super.didChangeDependencies();
  }

  void _changeDefaultMarker() {
    setState(() {
      defaultMarker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("map ${widget.initialLocation}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              print("backed location $_pickedLocation");
              Navigator.of(context).pop(
                  _pickedLocation == null ? defaultCords : _pickedLocation);
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
            center: LatLng(
              widget.initialLocation.latitude,
              widget.initialLocation.longitude,
            ),
            zoom: 18.0,
            onTap: (val) {
              _changeDefaultMarker();
              _selectLocation(val);
              print(val);
            }),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              defaultMarker
                  ? Marker(
                      point: widget.initialLocation,
                      width: 20,
                      height: 30,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    )
                  : Marker(
                      point: _pickedLocation,
                      width: 20,
                      height: 30,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
