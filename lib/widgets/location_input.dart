import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as lc;
import 'package:native_device_cide/helper/location_helper.dart';
import 'package:native_device_cide/screens/MapScreen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  bool _isLoading = false;
  LatLng defaultCords;
  LatLng backedResult;
  String mapBoxToken =
      "pk.eyJ1IjoiY2hpcmFnMDQ2OSIsImEiOiJja2x1bGxxYXIwamhsMm5zNXN0bXdtM2owIn0.IllYOMgnei87qftMxXJ-sg";

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoading = true;
    });
    final locationResult = await _getLocation();
    print(locationResult);
    final locationData = await lc.Location().getLocation();
    setState(() {
      _isLoading = false;

      final staticMapUrl = LocationHelper.getLocationPreviewImage(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
      _previewImageUrl = staticMapUrl;
      print(_previewImageUrl);
    });
    widget.onSelectPlace(locationData.latitude, locationData.longitude);
  }

  Future<LatLng> _getLocation() async {
    final locationData = await lc.Location().getLocation();
    defaultCords = LatLng(locationData.latitude, locationData.longitude);
    return defaultCords;
  }

  @override
  void didChangeDependencies() {
    _getLocation();
    // getPlacess();
    // getPlaces();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Colors.grey,
            )),
            child: _previewImageUrl == null
                ? Center(
                    child: Text(
                      "No Location chosen!",
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Text(""),
                      ),
                      Image.network(
                        _previewImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : FlatButton.icon(
                      onPressed: _getUserLocation,
                      icon: Icon(Icons.location_on_outlined),
                      label: Text("Get Current Location"),
                      textColor: Theme.of(context).accentColor,
                    ),
              FlatButton.icon(
                onPressed: () async {
                  print("pushing coords $defaultCords");
                  backedResult =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => MapScreen(
                        backedResult != null ? backedResult : defaultCords),
                    fullscreenDialog: true,
                  ));
                  setState(() {
                    final getUrl = LocationHelper.getLocationPreviewImage(
                      latitude: backedResult.latitude,
                      longitude: backedResult.longitude,
                    );
                    print(_previewImageUrl);
                    _previewImageUrl = getUrl;
                  });
                  widget.onSelectPlace(
                      backedResult.latitude, backedResult.longitude);
                },
                icon: Icon(Icons.map_outlined),
                label: Text("Select on Map"),
                textColor: Theme.of(context).accentColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
