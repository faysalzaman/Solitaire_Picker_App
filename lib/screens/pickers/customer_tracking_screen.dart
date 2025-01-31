// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solitaire_picker/cubit/journey/journey_cubit.dart';
import 'package:solitaire_picker/cubit/journey/journey_state.dart';
import 'package:solitaire_picker/model/active_picker_model.dart';
import 'dart:convert';

import 'package:solitaire_picker/screens/pickers/shops/select_shop_screen.dart';
import 'package:solitaire_picker/utils/app_loading.dart';
import 'package:solitaire_picker/utils/app_navigator.dart';

class CustomerTrackingScreen extends StatefulWidget {
  const CustomerTrackingScreen({
    super.key,
    required this.activePickerModel,
    required this.customerId,
  });

  final ActivePickerModel activePickerModel;
  final String customerId;

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  GoogleMapController? mapController;
  Position? currentPosition;
  Set<Marker> markers = {};
  Set<Polyline> _polylines = {};
  String? currentAddress;
  String? destinationAddress;
  String? _eta;
  double distanceInKm = 0.0;
  bool _isLoading = true;
  StreamSubscription<Position>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _startLocationUpdates();
  }

  Future<void> _initializeMap() async {
    print('Initializing map...');
    try {
      print('Getting current location...');
      await _getCurrentLocation();
      if (currentPosition != null) {
        print('Setting markers...');
        _setMarkers();
        print('Getting addresses...');
        await _getAddresses();
        print('Drawing route...');
        await _drawRoute();
        print('Calculating distance...');
        _calculateDistance();
      } else {
        print('Current position is null after getting location');
      }
    } catch (e, stackTrace) {
      debugPrint('Error initializing map: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading map: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('customer_location'),
        position: LatLng(widget.activePickerModel.customerLat ?? 0,
            widget.activePickerModel.customerLng ?? 0),
        infoWindow: InfoWindow(
            title: widget.activePickerModel.customer?.name ?? 'Customer'),
      ),
    );
    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  Future<void> _getAddresses() async {
    if (currentPosition != null) {
      currentAddress = await _getAddressFromLatLng(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
      );
      destinationAddress = await _getAddressFromLatLng(
        LatLng(widget.activePickerModel.customerLat ?? 0,
            widget.activePickerModel.customerLng ?? 0),
      );
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  void _calculateDistance() {
    if (currentPosition != null) {
      distanceInKm = Geolocator.distanceBetween(
            currentPosition!.latitude,
            currentPosition!.longitude,
            widget.activePickerModel.customerLat ?? 0,
            widget.activePickerModel.customerLng ?? 0,
          ) /
          1000;
    }
  }

  Future<void> _drawRoute() async {
    if (currentPosition == null) return;

    final String? googleAPIKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (googleAPIKey == null) {
      debugPrint('Google Maps API key is not configured');
      return;
    }

    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${currentPosition!.latitude},${currentPosition!.longitude}'
        '&destination=${widget.activePickerModel.customerLat},${widget.activePickerModel.customerLng}'
        '&key=$googleAPIKey';

    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['routes'].isNotEmpty) {
        String points = jsonData['routes'][0]['overview_polyline']['points'];
        List<LatLng> polylineCoordinates = _decodePolyline(points);

        // Calculate ETA
        if (jsonData['routes'][0]['legs'].isNotEmpty) {
          int durationInSeconds =
              jsonData['routes'][0]['legs'][0]['duration']['value'];
          DateTime estimatedArrival =
              DateTime.now().add(Duration(seconds: durationInSeconds));
          _eta = DateFormat('HH:mm').format(estimatedArrival);
        }

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Error drawing route: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _startLocationUpdates() {
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      setState(() {
        currentPosition = position;
        markers.removeWhere(
            (marker) => marker.markerId == const MarkerId('current_location'));
        markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'My Location'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });

      await _getAddresses();
      await _drawRoute();
      _calculateDistance();
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Customer Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: AppLoading(
                color: Colors.blue,
                size: 32,
              ),
            )
          : currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to load map',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please check your location settings and try again',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _initializeMap(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentPosition!.latitude,
                                  currentPosition!.longitude),
                              zoom: 12,
                            ),
                            markers: markers,
                            polylines: _polylines,
                            onMapCreated: (GoogleMapController controller) {
                              setState(() {
                                mapController = controller;
                              });
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            trafficEnabled: true,
                          ),
                        ),
                      ],
                    ),
                    // Add bottom sheet for navigation info
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    currentAddress ?? 'Current Location',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    destinationAddress ?? 'Destination',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Distance',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${distanceInKm.toStringAsFixed(1)} km',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'ETA',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      _eta ?? '--:--',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            BlocConsumer<JourneyCubit, JourneyState>(
                              listener: (context, state) {
                                if (state is JourneyLoaded) {
                                  Navigator.pop(context);
                                  AppNavigator.push(
                                    context,
                                    SelectShopScreen(
                                      activePickerModel:
                                          widget.activePickerModel,
                                      customerId: widget.customerId,
                                      journeyId: state.journey.id ?? "",
                                    ),
                                  );
                                } else if (state is JourneyError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: FilledButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                                'Congratulations! 🎉'),
                                            content: Text(
                                              'You have successfully met up with ${widget.activePickerModel.customer?.name}. You can now proceed with your shopping or continue with your services.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context
                                                      .read<JourneyCubit>()
                                                      .startJourney(
                                                          widget.customerId);
                                                },
                                                child: state is JourneyLoading
                                                    ? const AppLoading(
                                                        color: Colors.blue,
                                                        size: 16,
                                                      )
                                                    : const Text('Let\'s go!'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: state is JourneyLoading
                                        ? const AppLoading(
                                            color: Colors.blue,
                                            size: 16,
                                          )
                                        : const Text('Meet Customer'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
