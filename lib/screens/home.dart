import 'package:bus_iti/widgets/bus_card.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';
import '../models/bus.dart';
import 'package:bus_iti/services/bus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late Future<List<Bus>> buses;

  @override
  void initState() {
    super.initState();
    buses = BusLines().getBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ITI'),
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
              itemCount: buses.length,
              itemBuilder: (context, index) {
                Bus bus = buses[index];
                return BusCard(
                  title: bus.name,
                  start: bus.busPoints.isNotEmpty
                      ? bus.busPoints.first.pickupTime.toString()
                      : 'Not determined',
                  end: bus.busPoints.isNotEmpty
                      ? bus.busPoints.last.departureTime.toString()
                      : 'Not determined',
                  imageUrl: 'https://www.allstarvip.com/wp-content/uploads/2020/11/chartered-bus-sightseeing-tour.jpg',
                );
              },
            );
          }
        },
      ),
    );
  }
}
