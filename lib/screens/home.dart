// home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import '../widgets/bus_form.dart';
import 'package:bus_iti/widgets/bus_card.dart';
import 'package:bus_iti/services/bus.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';
import 'package:bus_iti/models/bus.dart';
import 'package:bus_iti/services/bus.dart';
import 'package:bus_iti/utils/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreen extends State<HomeScreen> {
  late Future<List<Bus>> buses;
  late Future<bool> isAdmin;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    buses = BusLines().getBuses();
    isAdmin = _initializeAdminCheck();
  }

  Future<bool> _initializeAdminCheck() async {
    CheckAuth auth = CheckAuth();
    await auth.init();
    return auth.isAdmin();
  }

  void _addBus(String name, int capacity, bool isActive, String? imagePath, List<Map<String, dynamic>> points, String driver) {
    // Add logic to handle the bus data (e.g., sending it to a server, updating local state, etc.)
    // For example, you could call a method on your Bus service to save the new bus:
    //BusLines().addBus(name, capacity, isActive, imagePath, points, driver);
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
      appBar: const CustomAppBar(title: 'ITI'),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Bus>>(
        future: futureBuses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Failed to load data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No buses available'));
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: buses.length,
              itemBuilder: (context, index) {
                final bus = snapshot.data![index];
                return BusCard(
                  title: bus.name,
                  start: bus.busPoints.isNotEmpty
                      ? bus.busPoints.first.formattedPickupTime
                      : 'Not determined',
                  end: bus.busPoints.isNotEmpty
                      ? bus.busPoints.last.formattedDepartureTime
                      : 'Not determined',
                  imageUrl: bus.imageUrl ?? '',
                  driverName: bus.driver?.name ?? 'Not determined',
                  driverPhoneNumber: bus.driver?.phoneNumber ?? 'Not determined',
                  busPoints: bus.busPoints,
                );
              },
            );
          }
        },
      ),
        floatingActionButton:/* FutureBuilder<bool>(
        future: isAdmin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
            return Container();
          } else {
            return FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => CreateBus(),
              ),
              child: const Icon(Icons.add),
            );
          }
        },
      ),*/
        ScrollingFabAnimated(
          icon: const Icon(Icons.add, color: Colors.white,),
          text: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 20.0),),
          color: const Color(0xFF850606),
          onPress: () => _navigateToAddBusForm(context),
          scrollController: _scrollController,
          animateIcon: true,
          inverted: false,
          radius: 10.0,
        )
    );
  }
}