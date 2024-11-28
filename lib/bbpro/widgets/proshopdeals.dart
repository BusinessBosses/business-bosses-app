import 'package:flutter/material.dart';

class ProshopdealsWidget extends StatelessWidget {
  const ProshopdealsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'New customer deals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Text(
                    'BLACK FRIDAY',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                const Icon(Icons.arrow_forward),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildDealItem(
                      'assets/fairy_liquid.png', // Replace with your image path
                      'Fairy Washing Liquid',
                      '-49%',
                      '£7.69'),
                  _buildDealItem(
                      'assets/smoke_detectors.png', // Replace with your image path
                      'Smoke Detectors',
                      '-21%',
                      '£19.35'),
                  _buildDealItem(
                      'assets/hoodie.png', // Replace with your image path
                      'Hoodie',
                      '-60%',
                      '£9.52'),
                  _buildDealItem(
                      'assets/phone.png', // Replace with your image path
                      'Phone',
                      '-14%',
                      '£100.49'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealItem(
      String imagePath, String title, String discount, String price) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            discount,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 4.0),
          Text(
            price,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
