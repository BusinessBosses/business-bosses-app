import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_header_item.dart';
import 'package:business_bosses_v2/features/withdrawal/widgets/withdrawal_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../navigation/routes.dart';

class DepositsScreen extends StatefulWidget {
  static const String routeName = '/deposits-screen';

  const DepositsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DepositsScreenState createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final ScrollController scrollController = ScrollController();
  final ProfileController _profileController = Get.find();
  String? _paymentmethods;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
       
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverStickyHeader(
                sticky: false,
                header: const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                      
                     
                      
                    ],
                  ),
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0),
            child: Container(
              child: Column(
                children: [
                  WithdrawalHeaderItem() ,
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int i) {
                          return  WithdrawalItem();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
