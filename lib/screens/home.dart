import 'package:bus_iti/widgets/bus_card.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'ITI'),
      drawer: CustomDrawer(),
      //body:BusCard(),
    );
}
}
