import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../bbpro/controllers/shop_controller.dart';
import '../../common/models/api_response_model.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../services/api_service.dart';
import '../../utils/theme/theme.dart';

/// Lets a shop owner set the coin reward paid to a referrer when someone they
/// referred completes a purchase at the shop.
class ShopReferralRewardScreen extends StatefulWidget {
  const ShopReferralRewardScreen({super.key});

  @override
  State<ShopReferralRewardScreen> createState() =>
      _ShopReferralRewardScreenState();
}

class _ShopReferralRewardScreenState extends State<ShopReferralRewardScreen> {
  final TextEditingController coinsController = TextEditingController();
  bool active = false;
  bool loading = true;
  bool saving = false;
  String? shopId;

  @override
  void initState() {
    super.initState();
    shopId = _resolveShopId();
    if (shopId != null) {
      _load();
    } else {
      loading = false;
    }
  }

  String? _resolveShopId() {
    try {
      final ShopController sc = Get.find<ShopController>();
      if (sc.shop?.id != null) return sc.shop!.id;
    } catch (_) {}
    try {
      return Get.find<ProfileController>().myProfile.shop?.id;
    } catch (_) {}
    return null;
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final ApiResponseModel res =
          await ApiService.get(path: 'shop-referral/$shopId');
      if (res.success == true && res.data != null) {
        coinsController.text =
            (res.data['coinsPerReferral'] ?? 0).toString();
        active = res.data['active'] == true;
      }
    } catch (_) {
      // ignore — show defaults
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _save() async {
    if (shopId == null) return;
    final int coins = int.tryParse(coinsController.text.trim()) ?? 0;
    if (active && coins <= 0) {
      Get.snackbar('Invalid amount',
          'Enter how many coins each successful referral earns.');
      return;
    }
    setState(() => saving = true);
    try {
      final ApiResponseModel res = await ApiService.post(
        path: 'shop-referral/$shopId',
        body: <String, dynamic>{'coinsPerReferral': coins, 'active': active},
      );
      if (res.success == true) {
        Get.snackbar('Saved', 'Referral reward updated.');
      } else {
        Get.snackbar('Error',
            res.message.isNotEmpty ? res.message : 'Failed to save reward.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : shopId == null
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'You need a shop to set up referral rewards.\nCreate a shop first, then come back here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                    const Text(
                      'Reward users with coins when they refer a buyer to your shop. '
                      'The reward is credited after the referred user completes a purchase.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable Referral Rewards', style: TextStyle(color: Colors.black)),
                      value: active,
                      onChanged: (bool v) => setState(() => active = v),
                      activeColor: Colors.black,
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade200,
                    ),
                    if (active) ...<Widget>[
                      const SizedBox(height: 8),
                      TextField(
                        controller: coinsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: 'Coins Per Successful Referral',
                          hintText: 'e.g., 50',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: proprimaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: saving ? null : _save,
                        child: saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Save Rewards', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                );
  }
}
