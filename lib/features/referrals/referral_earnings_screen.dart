import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/models/api_response_model.dart';
import '../../services/api_service.dart';
import '../../utils/currency_format.dart';

/// Shows the coins the current user has earned from shop referral rewards
/// (people who used their invite code and later completed a purchase).
class ReferralEarningsScreen extends StatefulWidget {
  const ReferralEarningsScreen({super.key});

  @override
  State<ReferralEarningsScreen> createState() => _ReferralEarningsScreenState();
}

class _ReferralEarningsScreenState extends State<ReferralEarningsScreen> {
  bool loading = true;
  int total = 0;
  List<dynamic> earnings = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final ApiResponseModel res =
          await ApiService.get(path: 'shop-referral/earnings');
      if (res.success == true && res.data != null) {
        total = int.tryParse('${res.data['total'] ?? 0}') ?? 0;
        earnings = (res.data['earnings'] as List<dynamic>?) ?? <dynamic>[];
      }
    } catch (_) {
      // ignore — show empty state
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Total referral coins earned',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/svgs/coin.svg',
                              height: 22, width: 22),
                          const SizedBox(width: 6),
                          Text(CurrencyFormatter.formatCoins(total),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(CurrencyFormatter.coinEquivalent(total),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (earnings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: Text(
                        'No referral earnings yet.\nInvite friends — you earn coins when they shop.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...earnings.map<Widget>(_tile),
              ],
            ),
          );
  }

  Widget _tile(dynamic item) {
    final int amount = int.tryParse('${item['amount'] ?? 0}') ?? 0;
    final String shop = (item['shopName'] ?? 'a shop').toString();
    final String who = (item['referredUser'] ?? 'Someone you referred').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('$who shopped at $shop',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text(CurrencyFormatter.coinEquivalent(amount),
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/svgs/coin.svg', height: 16, width: 16),
              const SizedBox(width: 3),
              Text('+${CurrencyFormatter.formatCoins(amount)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }
}
