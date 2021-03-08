const apiKey =
    "pk.eyJ1IjoiY2hpcmFnMDQ2OSIsImEiOiJja2x1bGxxYXIwamhsMm5zNXN0bXdtM2owIn0.IllYOMgnei87qftMxXJ-sg";

class LocationHelper {
  static String getLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l($longitude,$latitude)/$longitude,$latitude,14.25,0,0/600x300?access_token=$apiKey";
  }
}
