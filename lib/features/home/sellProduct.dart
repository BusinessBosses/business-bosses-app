import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void sellProduct(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                // Set a specific height
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        index == 0
                            ? Get.toNamed(Routes.sellscreen)
                            : Get.to(
                                () => const CreateServiceScreen(isUpd: false));
                      },
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(left: 10),
                      leading: SvgPicture.asset(
                        index == 0
                            ? 'assets/svgs/sellicon.svg'
                            : 'assets/svgs/sellicon.svg',
                        height: index == 0
                            ? 25
                            : index == 1
                                ? 30
                                : 22,
                        color: textColor.withOpacity(1),
                      ),
                      title: Text(
                        index == 0 ? 'Sell your product' : 'Sell your service',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
