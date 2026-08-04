import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shows where an order's coin payment currently stands.
///
/// The buyer's coins are held when they pay, stay held while the seller
/// delivers, and are credited to the seller after the escrow window. Both sides
/// need to see that: the buyer that the order is paid, the seller that the
/// coins exist but are not theirs yet.
class OrderPaymentStatus extends StatelessWidget {
  const OrderPaymentStatus({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final OrderEscrow? escrow = order.escrow;
    // Orders paid outside coins have no escrow record — nothing to show.
    if (escrow == null || escrow.coinAmount <= 0) return const SizedBox.shrink();

    final String myUid = Get.find<ProfileController>().myProfile.uid;
    final bool isSeller = escrow.sellerId == myUid;

    late final IconData icon;
    late final Color accent;
    late final String heading;
    late final String detail;

    if (escrow.isRefunded) {
      icon = LucideIcons.undo2;
      accent = Colors.orange.shade800;
      heading = 'Refunded';
      detail = isSeller
          ? '${escrow.coinAmount} coins were returned to the buyer.'
          : '${escrow.coinAmount} coins were returned to you.';
    } else if (escrow.isReleased) {
      icon = LucideIcons.checkCircle2;
      accent = Colors.green.shade700;
      heading = 'Paid • ${escrow.coinAmount} coins';
      detail = isSeller
          ? 'Released to your wallet.'
          : 'Released to the seller.';
    } else {
      // held or delivered — paid, but not the seller's yet.
      icon = LucideIcons.lock;
      accent = primaryColorLT;
      heading = 'Paid • ${escrow.coinAmount} coins';
      if (isSeller) {
        detail = escrow.status == 'delivered'
            ? 'Coins are on hold${_releaseSuffix(escrow)}.'
            : 'Coins are on hold and will be released to you once you deliver '
                'this order.';
      } else {
        detail = 'Your coins are safely on hold until you receive this order.';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 13, color: subtextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// " until 5 Aug" when a release date is known, otherwise nothing.
  String _releaseSuffix(OrderEscrow escrow) {
    if (escrow.releaseAt == null) return '';
    return ' until ${DateFormat('d MMM').format(escrow.releaseAt!)}';
  }
}
