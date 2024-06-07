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
    if (picked != null && picked != (isStart ? selectedStartDate : selectedEndDate))
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jagaraga'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
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
                Text('Car Type', style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CarTypeWidget(carType: 'LCGC'),
                      CarTypeWidget(carType: 'SUV'),
                      CarTypeWidget(carType: 'Cabriolet'),
                      CarTypeWidget(carType: 'Hatchback'),
                      CarTypeWidget(carType: 'MPV'),
                      // Add more car types if needed
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Available Near You', style: Theme.of(context).textTheme.headline6),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Image.asset('assets/${carType.toLowerCase()}_icon.png', width: 100),
          Text(carType),
        ],
      ),
    );
  }
}

void main() {
  runApp(JagaragaApp());
}

class JagaragaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jagaraga',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'JAGARAGA',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Rent a vehicle safely and comfortably',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
            TextButton(
              child: Text('Login'),
              onPressed: () {
                // Navigate to login page
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Your email address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                // Simulate a successful sign up process
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            SizedBox(height: 8),
            TextButton(
              child: Text('Already have an account? Login'),
              onPressed: () {
                // Navigate to login page
              },
            ),
          ],
        ),
      ),
    );
  }
}
