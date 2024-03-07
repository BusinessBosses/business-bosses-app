import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../navigation/routes.dart';

class WithdrawalScreen extends StatefulWidget {
  static const String routeName = '/withdrawal-screen';

  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late String _referralId;
  final ProfileController _profileController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _referralId = _profileController.myProfile.inviteId!;
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: backgroundcolorinterface,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'My Coin Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      SvgPicture.asset(
                        'assets/svgs/coin.svg',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '${_profileController.myProfile.coinscount ?? 0}',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Withdraw'),
                    SvgPicture.asset('assets/svgs/help.svg')
                  ],
                ),
                Text('Withdrawable Balance'),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: backgroundcolorinterface,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15),
                    child: Text('data'),
                  ),
                ),
                Text('Payment Method'),
                Text('Destination Address'),
                ElevatedButton(onPressed: (){}, child: Text('Withdraw')),
                Container(
                  height: 200,
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int i) {
                        return Text('data');
                      },
                    ),
                ),
              ],
            ),
          ),
        ));
  }
}
