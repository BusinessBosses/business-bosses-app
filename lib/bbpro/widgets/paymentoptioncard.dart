import 'package:flutter/material.dart';

class ProPaymentOptionCard extends StatelessWidget {
  const ProPaymentOptionCard({
    super.key,
    required this.option,
    required this.activeoption,
    required this.onTap,
    required this.subtext,
  });

  final String option; // Each option is a String, not a List
  final String activeoption; // The currently active option
  final Function(String) onTap; // Callback function
  final String subtext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(option); // Pass the selected option
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: option == activeoption
                ? Colors.black
                : const Color.fromRGBO(0, 0, 0, 0.0530),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      option, // Use the string directly
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    // Text(
                    //   subtext,
                    //   style: const TextStyle(fontSize: 12),
                    // )
                  ],
                ),
                option == activeoption
                    ? const CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(0xFFf4f4f4),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.white,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
