import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/currency_format.dart';

/// Renders a listing price in coins (main line, with a coin icon) and the user's
/// chosen-currency equivalent underneath. Converts the fiat [price] (denominated
/// in [currencyCode], the listing/shop currency) to coins via the $1 = 1000 peg.
///
/// Pass [originalPrice] to show a struck-through pre-discount coin price beside
/// the current one.
class CoinPriceLabel extends StatelessWidget {
  const CoinPriceLabel({
    super.key,
    required this.price,
    this.originalPrice,
    this.currencyCode,
    this.priceStyle,
    this.alignment = CrossAxisAlignment.start,
  });

  final num? price;
  final num? originalPrice;
  final String? currencyCode;
  final TextStyle? priceStyle;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final int coins =
        CurrencyFormatter.coinsForPrice(price, currencyCode: currencyCode);
    final TextStyle mainStyle = priceStyle ??
        const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        );
    final bool showOriginal = originalPrice != null &&
        originalPrice!.toDouble() > (price?.toDouble() ?? 0);

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Primary: price in the user's chosen currency.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(CurrencyFormatter.formatCurrency(coins), style: mainStyle),
            if (showOriginal) ...<Widget>[
              const SizedBox(width: 5),
              Text(
                CurrencyFormatter.formatCurrency(
                    CurrencyFormatter.coinsForPrice(originalPrice,
                        currencyCode: currencyCode)),
                style: mainStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: (mainStyle.fontSize ?? 13) - 2,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        // Secondary: coin amount.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset('assets/svgs/coin.svg', height: 12, width: 12),
            const SizedBox(width: 3),
            Text('${CurrencyFormatter.formatCoins(coins)} coins',
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
