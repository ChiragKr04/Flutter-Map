const apiKey =
    "pk.eyJ1IjoiY2hpcmFnMDQ2OSIsImEiOiJja2x1bGxxYXIwamhsMm5zNXN0bXdtM2owIn0.IllYOMgnei87qftMxXJ-sg";

class LocationHelper {
  static String getLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    // return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey";
    // return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/-122.337798,37.810550,9.67,0.00,0.00/1000x600@2x?access_token=$googleApiKey";
    return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l($longitude,$latitude)/$longitude,$latitude,14.25,0,0/600x300?access_token=$apiKey";
  }
}
