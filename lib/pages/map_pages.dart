import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_finder/pages/consts.dart';
import 'package:garage_finder/pages/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart' as IMG;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng? _center; // Center will be set to the user's current location
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _selectedMarkerPosition;
  final String _apiKey = GOOGLE_MAPS_API_KEY;
  Uint8List? _inputLocationIcon;

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
    _requestLocationPermission().then((permissionGranted) {
      if (permissionGranted) {
        _getCurrentLocation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Location permission is required to find nearby mechanics.')),
        );
      }
    });
  }

  Future<bool> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    return status.isGranted;
  }

  Future<void> _setCustomMarker() async {
    Uint8List userLocation =
        (await rootBundle.load('lib/images/pick-pin-icon.png'))
            .buffer
            .asUint8List();

    _inputLocationIcon = resizeImage(userLocation, 100, 110);
  }

  Uint8List? resizeImage(Uint8List data, width, height) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
    resizedData = Uint8List.fromList(IMG.encodePng(resized));
    return resizedData;
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    _findNearbyMechanics();
  }

  Future<void> _findNearbyMechanics() async {
    if (_center == null) return;

    final location = '${_center!.latitude},${_center!.longitude}';
    final radius = 5000; // Search radius in meters
    final type = 'car_repair'; // Place type

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&type=$type&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('input_location'),
            position: _center!,
            icon: BitmapDescriptor.fromBytes(_inputLocationIcon!),
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        );

        for (var result in results) {
          final lat = result['geometry']['location']['lat'];
          final lng = result['geometry']['location']['lng'];
          final markerId = result['place_id'];
          final marker = Marker(
            markerId: MarkerId(markerId),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: result['name'],
              snippet: result['vicinity'],
            ),
            onTap: () {
              setState(() {
                _selectedMarkerPosition = LatLng(lat, lng);
                _drawPolyline();
              });
              _showPairWithMechanicDialog(result['name']);
            },
          );
          _markers.add(marker);
        }
      });
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _drawPolyline() async {
    if (_center == null || _selectedMarkerPosition == null) return;

    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_center!.latitude},${_center!.longitude}&destination=${_selectedMarkerPosition!.latitude},${_selectedMarkerPosition!.longitude}&key=$_apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final points = data['routes'][0]['overview_polyline']['points'];
        final polylineCoordinates = _decodePolyline(points);
        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              visible: true,
              points: polylineCoordinates,
              width: 5,
              color: Colors.blue,
            ),
          );
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  List<LatLng> _decodePolyline(String poly) {
    List<LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showPairWithMechanicDialog(String garageName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pair with Mechanic'),
          content: Text('Do you want to pair with a mechanic at $garageName?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Pair'),
              onPressed: () {
                // Handle the pairing action here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Tap on the nearest garage'),
      ),
      body: _center == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center!,
                zoom: 12.0,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
    );
  }
}
