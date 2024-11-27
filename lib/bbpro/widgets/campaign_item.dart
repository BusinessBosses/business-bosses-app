import 'package:business_bosses_v2/bbpro/models/campaign_model.dart';
import 'package:flutter/cupertino.dart';

class CampaignItem extends StatefulWidget {
  final Campaign campaign;
  const CampaignItem({super.key, required this.campaign});

  @override
  State<CampaignItem> createState() => _CampaignItemState();
}

class _CampaignItemState extends State<CampaignItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.campaign.campaignName),
        Text(widget.campaign.message),
        Text('Clients Sent: ${widget.campaign.clientIds.length}'),
      ],
    );
  }
}
