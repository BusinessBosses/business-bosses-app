import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

Widget sellingGuide(BuildContext context) {
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
          const Text(
              'All listings created on Business Bosses must meet the following guidelines or the listing and the user account will be deleted and banned permanently.'),
          const SizedBox(
            height: 20,
          ),
          Text(
            'GUIDELINES',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 3,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('🚫 ', style: bodyText2),
              Expanded(
                child: Text(
                    'Weapons, ammunitions, explosives, and hazardous goods listings are not allowed',
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
              Text('🚫  ', style: bodyText2),
              Expanded(
                child: Text(
                    'Human trafficking, prostitution, escort, sexual services or pornographic listings are not allowed',
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
              Text('🚫  ', style: bodyText2),
              Expanded(
                child: Text(
                    'Illegal Drugs, Prescription or Recreational Drugs, Other Drug paraphernalia and alcohol listings is not allowed',
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
              Text('🚫  ', style: bodyText2),
              Expanded(
                child: Text(
                    'You cannot list stolen goods and your listing must not infringe intellectual property rights of a third-party (e.g. copyright)',
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
              Text('🚫  ', style: bodyText2),
              Expanded(
                child: Text(
                    'Selling animals and posting about animals for adoption listings are not allowed',
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
              Text('✅  ', style: bodyText2),
              Expanded(
                child: Text(
                    'Ensure any image and description are honest and fair.',
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
              Text('✅  ', style: bodyText2),
              Expanded(
                child: Text(
                    "Business Bosses does not offer an in-built payment feature yet, it's down to you to choose a payment provider that offers buyer protection (e.g PayPal)",
                    style: bodyText2),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.safeBlockHorizontal * 3,
          ),
        ],
      ),
    ),
  );
}
