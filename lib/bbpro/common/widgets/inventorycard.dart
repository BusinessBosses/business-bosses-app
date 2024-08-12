import 'package:business_bosses_v2/bbpro/common/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class InventoryCard extends StatefulWidget {
  final String cardName;
  final String value;

  const InventoryCard({
    required this.cardName,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120.0,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetworkImageWithPlaceHolder(
                imageUrl: '',
                radius: radius,
                placeHolder: Icons.person,
                iconSize: 0.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                widget.cardName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                widget.value,
                style: TextStyle(
                  color: proprimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 5,
                  ),
                  SizedBox(width: 3),
                  Text('Out of stock', style: TextStyle(fontSize: 10), ),
                ],
              ),
              OptionsButton(),
            ],
          ),
        ],
      ),
    );
  }
}
