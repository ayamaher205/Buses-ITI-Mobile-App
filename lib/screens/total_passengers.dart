import 'package:bus_iti/widgets/custom_appBar.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bus_iti/models/bus.dart';

import '../services/bus.dart';

class TotalPassengersScreen extends StatefulWidget {
  @override
  _TotalPassengersScreenState createState() => _TotalPassengersScreenState();
}

class _TotalPassengersScreenState extends State<TotalPassengersScreen> {
  List<Bus> buses = [];

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<void> fetchBuses() async {
    BusLines busLines = BusLines();
    List<Bus> buses = await busLines.getBuses();
    setState(() {
      this.buses = buses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Total Passengers',
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 1.5)),
          children: [
            // Table header
            const TableRow(children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "BUS NAME",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "NUMBER OF PASSENGERS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
            ]),
            // Dynamic data rows
            ...buses.map(
                  (bus) {
                int numberOfPassengers =
                bus.remainingSeats != null
                    ? bus.capacity - bus.remainingSeats!
                    : 0;
                return TableRow(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(bus.name),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(numberOfPassengers.toString()),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}
