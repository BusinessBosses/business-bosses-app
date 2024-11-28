import 'package:flutter/material.dart';

class ProshopdealsWidget extends StatelessWidget {
  const ProshopdealsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(13.0),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text(
                    'Pro users deals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text(
                      'NEW OFFERS',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 100,
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
    );
  }

  Widget _buildDealItem(
      String imagePath, String title, String discount, String price) {
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8.0),
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
