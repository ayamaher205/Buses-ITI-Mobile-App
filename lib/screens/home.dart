import 'package:flutter/material.dart';
import 'package:bus_iti/models/bus.dart';
import 'package:bus_iti/widgets/bus_card.dart';
import 'package:bus_iti/services/bus.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Bus>> futureBuses;

  @override
  void initState() {
    super.initState();
    futureBuses = BusLines().getBuses();
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
              itemCount: snapshot.data!.length,
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
    );
  }
}
