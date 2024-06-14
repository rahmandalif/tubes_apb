import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:tubes/pages/camera.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(const Duration(days: 1));
  Position? _currentPosition;
  String _currentAddress = 'Fetching address...';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        if (isStartDate) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jagaraga'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'What are you looking for?',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Pick-up'),
                  subtitle: Text(DateFormat('dd, MM, yyyy').format(selectedStartDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Return'),
                  subtitle: Text(DateFormat('dd, MM, yyyy').format(selectedEndDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Perform search action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Search Car'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder : (context) => const PickImage())
              );
            },
            child: Container(
              width: 200,
              height: 200,
              color: Colors.transparent, // Set the color to make it visible
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Camera',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Car Type', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CarTypeWidget(carType: 'lib/assets/pict/mobil1.jpg'),
                CarTypeWidget(carType: 'lib/assets/pict/mobil2.jpg'),
                CarTypeWidget(carType: 'lib/assets/pict/mobil1.jpg'),
                CarTypeWidget(carType: 'lib/assets/pict/mobil2.jpg'),
                CarTypeWidget(carType: 'lib/assets/pict/mobil1.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Available Near You', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          SizedBox(
            height: 200, // Fixed height for the map
            child: Center(
              child: _currentPosition == null
                  ? const CircularProgressIndicator()
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Current Location:'),
                  Text('Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}'),
                  Text('Address: $_currentAddress'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarTypeWidget extends StatelessWidget {
  final String carType;

  const CarTypeWidget({Key? key, required this.carType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(
        carType,
        width: 350,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: MyHomePage()));
