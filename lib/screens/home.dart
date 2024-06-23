import 'package:flutter/material.dart';
import 'package:bus_iti/widgets/bus_card.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';
import 'package:bus_iti/models/bus.dart';
import 'package:bus_iti/services/bus.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';

import '../services/user_auth.dart';
import '../widgets/bus_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late Future<List<Bus>> buses;
  late Future<bool> isAdmin;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    buses = BusLines().getBuses();
    isAdmin = _checkIfAdmin();
  }

  Future<bool> _checkIfAdmin() async {
    final role = await UserAuth().getUserRoleFromToken();
    return role == 'admin';
  }

  void _addBus(String name, int capacity, bool isActive, String? imagePath, List<Map<String, dynamic>> points, String driver) {
    //BusLines().addBus(name, capacity, isActive, imagePath, points, driver);
    setState(() {
      buses = BusLines().getBuses(); // Refresh the list of buses
    });
  }

  void _navigateToAddBusForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusForm(
          onSaved: _addBus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Routes'),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Bus>>(
        future: buses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Failed to load data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No buses available'));
          } else {
            List<Bus> buses = snapshot.data!;
            return ListView.builder(
              controller: _scrollController,
              itemCount: buses.length,
              itemBuilder: (context, index) {
                Bus bus = buses[index];
                return BusCard(
                  title: bus.name,
                  start: bus.busPoints.isNotEmpty
                      ? bus.busPoints.first.formattedPickupTime
                      : 'Not determined',
                  end: bus.busPoints.isNotEmpty
                      ? bus.busPoints.last.formattedDepartureTime
                      : 'Not determined',
                  imageUrl: bus.imageUrl ?? '',
                  driverId: bus.driver?.id ?? '',
                  driverName: bus.driver?.name ?? 'Not determined',
                  driverPhoneNumber: bus.driver?.phoneNumber ?? 'Not determined',
                  busPoints: bus.busPoints,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: isAdmin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // Or a placeholder
          } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
            return const SizedBox(); // Hide FAB if not admin or error occurred
          } else {
            return ScrollingFabAnimated(
              icon: const Icon(Icons.add, color: Colors.white),
              text: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 20.0)),
              color: const Color(0xFF850606),
              onPress: () => _navigateToAddBusForm(context),
              scrollController: _scrollController,
              animateIcon: true,
              inverted: false,
              radius: 10.0,
            );
          }
        },
      ),
    );
  }
}
