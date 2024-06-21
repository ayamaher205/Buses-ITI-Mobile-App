import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  final String title;
  final String start;
  final String end;
  final String imageUrl;

  const BusCard({
    super.key,
    required this.title,
    required this.start,
    required this.end,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Morning: $start AM',
                        style: const TextStyle(fontSize: 15.0),
                      ),
                      Text(
                        'Departure: $end PM',
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: TextButton(
                    onPressed: () {
                      print("ffffffffffff");
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const BusLine(),
                      //   ),
                      // );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFFD22525),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
