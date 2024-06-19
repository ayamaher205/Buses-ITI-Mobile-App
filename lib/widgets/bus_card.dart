import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  const BusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Add margin around the card
      child: SizedBox(
        height: 100.0, // Set a fixed height for the card
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    'https://www.allstarvip.com/wp-content/uploads/2020/11/chartered-bus-sightseeing-tour.jpg',
                    fit: BoxFit.cover,
                    width: 60,
                    height: 80,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title of the Card',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'Start: 6:45 PM',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Text(
                        'End: 6:45 PM',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        print('Details button pressed');
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFFD22525)),
                        textStyle: WidgetStateProperty.all<TextStyle>(
                          const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        shape: WidgetStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: const Text('Details'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  const BusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 120.0,
        child: Card(
          //color:  const Color(0x88EFEFEF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
          ),
          elevation: 5, // Adds shadow to the card
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Padding inside the card
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://www.allstarvip.com/wp-content/uploads/2020/11/chartered-bus-sightseeing-tour.jpg',
                    fit: BoxFit.cover,
                    width: 60,
                    height: 70,
                  ),
                ),
                const SizedBox(width: 16.0), // Space between image and text
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title of the Card',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Start: 6:45 PM',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'End: 6:45 PM',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    // Handle details button press
                    print('view bus details');
                  },
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color:  Color(0xFFD22525),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/