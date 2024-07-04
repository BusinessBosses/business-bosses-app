import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

Widget suppliersGuide(BuildContext context) {
  return Dialog(
    backgroundColor: backgroundColor,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    insetPadding: const EdgeInsets.all(10),
    child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: SizeConfig.safeBlockVertical * 3,
          ),
          Text(
            'Guidelines for Supplier Contact Details Submission',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
          ),
          const Text(
              'Please ensure accurate supplier contact information before submitting on Business Bosses marketplace. See below guidelines:'),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 3,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('1. ', style: bodyText2),
              Expanded(
                child: Text(
                    'Supplier offerings: The supplier MUST be selling at wholesale or factory prices, so buyers can resell. DO NOT add a retailer',
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('2. ', style: bodyText2),
              Expanded(
                child: Text(
                    'Complete Contact Information: You MUST add accurate suppliers contact details, including the company name, email address, phone number, physical address, and any relevant social media or website links.',
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('3. ', style: bodyText2),
              Expanded(
                child: Text(
                    'Review and Approval Process: All added supplier are subject to an approval process before they are visible on Business Bosses to maintain listings.',
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('4. ', style: bodyText2),
              Expanded(
                child: Text(
                    'Verification Process: To have the verified badge, The supplier MUST be Validated by Bosses Bosses via physical or online verification process to ensure authenticity and prevent inaccuracies or fraudulent submissions.',
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('5. ', style: bodyText2),
              Expanded(
                child: Text(
                    'Privacy and Data Protection: All added suppliers contact details will be about how their contact information will be displayed across Business Bosses ecosystem and stored in compliance with data privacy regulations.',
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 3,
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('6. ', style: bodyText2),
              Expanded(
                child: Text(
                    'Manage Supplier Contact: If you own or manages the suppliers business, contact us at support@businessbosses.co.uk to update, manage or delete supplier details',
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
        ],
      ),
    ),
  );
}
