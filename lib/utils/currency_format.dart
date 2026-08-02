import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:get/get.dart';
import '../common/models/user_model.dart';
import '../features/marketplace/widgets/currency.dart';
import '../services/api_service.dart';
import '../features/profile/controller/profile_controller.dart';

/// Coin <-> currency helpers, backed by the `currency/rates` endpoint
/// ({ base, coinToUsd, rates, updatedAt }). All methods degrade gracefully to
/// the $1 = 100-coin default when rates haven't loaded yet.
class CurrencyFormatter {
  static Map<String, dynamic>? _ratesCache;

  static Future<void> initRates() async {
    try {
      final ApiResponseModel response =
          await ApiService.get(path: 'currency/rates');
      if (response.success == true && response.data != null) {
        if (response.data is Map) {
          _ratesCache = Map<String, dynamic>.from(response.data as Map<dynamic, dynamic>);
        }
      }
    } catch (e) {
      print('CurrencyFormatter.initRates error: $e');
      // ignore — callers fall back to the 100:1 default
    }
  }

  static double get _coinToUsd =>
      (_ratesCache?['coinToUsd'] ?? 100).toDouble();

  /// Units of [code] per 1 USD (rates are USD-based). Defaults to 1.0 when the
  /// rate isn't available so callers never crash / divide by zero.
  static double _rateFor(String code) {
    if (code == 'USD') return 1.0;
    final Map rates = (_ratesCache?['rates'] as Map?) ?? {};
    final dynamic v = rates[code];
    if (v is num && v > 0) return v.toDouble();
    final double? parsed = double.tryParse('$v');
    return (parsed != null && parsed > 0) ? parsed : 1.0;
  }

  /// The currency to display equivalents in, derived from the user's location:
  /// 1. the currency of their selected country;
  /// 2. otherwise USD (no country set, or country not recognised).
  ///
  /// Location is the single source of truth — everyone in a country sees one
  /// currency, so a listing wall never mixes currencies.
  static String preferredCurrencyCode() {
    try {
      final UserModel profile = Get.find<ProfileController>().myProfile;
      final String? country = profile.location;
      if (country != null && country.isNotEmpty) {
        final String? code = currencyValues[country.trim()];
        if (code != null && code.isNotEmpty) return code.toUpperCase();
      }
      return 'USD';
    } catch (_) {
      return 'USD';
    }
  }

  /// Coins -> the user's chosen display currency, no prefix, e.g. "NGN 1,234.56"
  /// or "$12.00". For use as a primary price.
  static String formatCurrency(int? coins) {
    final String code = preferredCurrencyCode();
    final double amount = ((coins ?? 0) / _coinToUsd) * _rateFor(code);
    final String formattedAmount = _formatAmount(amount);
    if (code == 'USD') return '\$$formattedAmount';
    return '$code $formattedAmount';
  }

  static String _formatAmount(double amount) {
    final double a = amount.abs();
    final String sign = amount < 0 ? '-' : '';
    if (a >= 1000000) return '$sign${_trim(a / 1000000)}M';
    if (a >= 1000) return '$sign${_trim(a / 1000)}K';
    return _money(amount);
  }

  /// Coins -> chosen display currency with an "≈" prefix, e.g. "≈ NGN 1,234.56".
  static String coinEquivalent(int? coins) => '≈ ${formatCurrency(coins)}';

  /// A job budget formatted in the user's location currency (the same way
  /// marketplace prices are shown), or `null` when no budget was set so callers
  /// can hide the field entirely instead of rendering a misleading "$0".
  ///
  /// A job carries a single figure. The API still stores start/end, and older
  /// records hold a genuine range, so the start is shown (falling back to the
  /// end) rather than "x - y". [sourceCurrency] is the currency the raw budget
  /// numbers are stored in (USD today).
  static String? budgetRange(num? start, num? end,
      {String sourceCurrency = 'USD'}) {
    final double s = (start ?? 0).toDouble();
    final double e = (end ?? 0).toDouble();
    final double amount = s > 0 ? s : e;
    if (amount <= 0) return null;
    return formatCurrency(coinsForPrice(amount, currencyCode: sourceCurrency));
  }

  /// Fiat [price] (in [currencyCode], the listing/shop currency) -> coins,
  /// using the $1 = coinToUsd peg. If the rate for [currencyCode] isn't loaded
  /// yet, the price is treated as USD (best-effort, display only).
  static int coinsForPrice(num? price, {String? currencyCode}) {
    if (price == null) return 0;
    final String code = (currencyCode ?? 'USD').toUpperCase();
    final double usd = price.toDouble() / _rateFor(code);
    return (usd * _coinToUsd).round();
  }

  /// Coin amount abbreviated: 1500 -> "1.5K", 2000000 -> "2M", 999 -> "999".
  static String formatCoins(int coins) {
    final int a = coins.abs();
    final String sign = coins < 0 ? '-' : '';
    if (a >= 1000000) return '$sign${_trim(a / 1000000)}M';
    if (a >= 1000) return '$sign${_trim(a / 1000)}K';
    return '$coins';
  }

  /// One decimal, dropping a trailing ".0" (2.0 -> "2", 2.5 -> "2.5").
  static String _trim(double v) {
    final String s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  /// Inserts thousands-separator commas into a plain integer string.
  static String _withCommas(String intDigits) {
    return intDigits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (Match m) => '${m[1]},',
    );
  }

  /// Money amount with commas + 2 decimals, e.g. 1234567.5 -> "1,234,567.50".
  static String _money(double amount) {
    final bool neg = amount < 0;
    final String fixed = amount.abs().toStringAsFixed(2);
    final List<String> parts = fixed.split('.');
    final String out = '${_withCommas(parts[0])}.${parts[1]}';
    return neg ? '-$out' : out;
  }
}
