import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 1));
  Position? _currentPosition;
  String _currentAddress = 'Fetching address...';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? selectedStartDate : selectedEndDate)) {
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
        title: Text('Jagaraga'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'What are you looking for?',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Pick-up'),
                  subtitle: Text(DateTime.now().timeZoneName),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Return'),
                  subtitle: Text(Date("dd, mm, yyyy").timeZoneName),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Perform search action
            },
            child: Text('Search Car'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          Text('Car Type', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CarTypeWidget(carType: 'lib/assets/mobil1.jpg'),
                CarTypeWidget(carType: 'lib/assets/mobil2.jpg'),
                CarTypeWidget(carType: 'lib/assets/mobil1.jpg'),
                CarTypeWidget(carType: 'lib/assets/mobil2.jpg'),
                CarTypeWidget(carType: 'lib/assets/mobil1.jpg'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text('Available Near You', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 10),
          Container(
            height: 200, // Fixed height for the map
            child: Center(
              child: _currentPosition == null
                  ? CircularProgressIndicator()
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Current Location:'),
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

  CarTypeWidget({required this.carType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(
        carType,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}
