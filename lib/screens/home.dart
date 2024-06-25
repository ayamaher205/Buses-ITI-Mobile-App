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
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late Future<List<Bus>> buses;
  late Future<bool> isAdmin;
  late Future<String> userId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    buses = BusLines().getBuses();
    isAdmin = _checkIfAdmin();
    userId = _getUserId();
  }

  Future<bool> _checkIfAdmin() async {
    final role = await UserAuth().getUserRoleFromToken();
    return role == 'admin';
  }

  Future<String> _getUserId() async {
    return await UserAuth().getUserIdFromToken();
  }

  void _addBus(String name, int capacity, bool isActive, String? imagePath, List<Map<String, dynamic>> points, String departureTime, String arrivalTime) async {
    await BusLines().createBus(name, capacity, isActive, imagePath, points, departureTime, arrivalTime);
    setState(() {
      buses = BusLines().getBuses();
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
            return FutureBuilder<String>(
              future: userId,
              builder: (context, userIdSnapshot) {
                if (userIdSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userIdSnapshot.hasError) {
                  return const Center(child: Text('Error: Failed to load user data'));
                } else if (!userIdSnapshot.hasData) {
                  return const Center(child: Text('No user data available'));
                } else {
                  String userId = userIdSnapshot.data!;
                  List<Bus> buses = snapshot.data!;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: buses.length,
                    itemBuilder: (context, index) {
                      Bus bus = buses[index];
                      return BusCard(
                        userId: userId,
                        title: bus.name,
                        start: bus.formattedArrivalTime.isNotEmpty
                            ? bus.formattedArrivalTime
                            : 'Not determined',
                        end: bus.formattedDepartureTime.isNotEmpty
                            ? bus.formattedDepartureTime
                            : 'Not determined',
                        imageUrl: bus.imageUrl ?? '',
                        busId: bus.id,
                        driverId: bus.driver?.id ?? '',
                        driverName: bus.driver?.name ?? 'Not determined',
                        driverPhoneNumber: bus.driver?.phoneNumber ?? 'Not determined',
                        busPoints: bus.busPoints,
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: isAdmin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
            return const SizedBox();
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
