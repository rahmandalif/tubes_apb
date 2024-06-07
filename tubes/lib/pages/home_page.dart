import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 1));
  GoogleMapController? mapController;

  final LatLng _center = const LatLng(-6.1753924, 106.8271528); // Example coordinates

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStart ? selectedStartDate : selectedEndDate)) {
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
    }
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
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(selectedStartDate)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Return'),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(selectedEndDate)),
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
          Text('Car Type', style: Theme.of(context).textTheme.headlineLarge),
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
          Text('Available Near You', style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: 10),
          Container(
            height: 200, // Fixed height for the map
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
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

