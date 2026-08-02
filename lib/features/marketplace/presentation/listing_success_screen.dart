import 'package:business_bosses_v2/bbpro/presentation/proshopdealsscreen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/expandedsupplierspage.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/request_details_sheet.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ListingSuccessScreen extends StatefulWidget {
  final bool isBuyerRequest;
  final String industry;
  final String location;
  final String? productId;
  final String? serviceId;

  /// Whether the listing was saved as active. An inactive listing is filtered
  /// out of the marketplace, so the success screen has to say so — otherwise
  /// "Listing Created!" is followed by the listing being nowhere to be found.
  final bool isActive;

  const ListingSuccessScreen({
    super.key,
    required this.isBuyerRequest,
    required this.industry,
    required this.location,
    this.productId,
    this.serviceId,
    this.isActive = true,
  });

  @override
  State<ListingSuccessScreen> createState() => _ListingSuccessScreenState();
}

class _ListingSuccessScreenState extends State<ListingSuccessScreen> {
  final SupplierController supplierController = Get.find();
  final BuyerRequestController buyerRequestController = Get.find();

  List<dynamic> results = <dynamic>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    setState(() => isLoading = true);

    // Give a small delay to ensure data is synced if needed,
    // though we are filtering from what's already in the controllers
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (widget.isBuyerRequest) {
      // Show sellers in their industry/location
      results = supplierController.suppliers.where((SuppliersModel s) {
        final bool matchIndustry = s.category?.toLowerCase().trim() ==
            widget.industry.toLowerCase().trim();
        final bool matchLocation = s.location?.toLowerCase().trim() ==
            widget.location.toLowerCase().trim();
        return matchIndustry && matchLocation;
      }).toList();
    } else {
      // A product/service listing shows no jobs — the seller just listed
      // something, matching them to job posts is noise. They get the
      // "we'll notify you when a buyer is found" state instead.
      results = <dynamic>[];
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          _buildSuccessHeader(),
          Expanded(
            child: _buildResultsSection(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    // Determine if we should show the matching message
    final bool hasResults = !isLoading && results.isNotEmpty;

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.checkCircle2,
            color: Colors.green,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.isBuyerRequest ? 'Job Posted!' : 'Listing Created!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            widget.isBuyerRequest
                ? hasResults
                    ? 'Your job is now live. Here are some people who can help.'
                    : 'Your job is now live.'
                : hasResults
                    ? 'Your listing is now live. Here are some buyers looking for what you offer.'
                    : 'Your listing is now live.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
        _buildVisibilityNote(),
      ],
    );
  }

  /// Tells the user where the listing will actually surface. The marketplace
  /// grid is filtered by the browsing location, so a listing posted for another
  /// location won't be in the default view — that is expected, not a failure.
  Widget _buildVisibilityNote() {
    final bool isHidden = !widget.isBuyerRequest && !widget.isActive;
    final String location = widget.location.trim();

    if (!isHidden && location.isEmpty) return const SizedBox.shrink();

    final Color accent = isHidden ? Colors.orange.shade800 : primaryColorLT;
    final String message = isHidden
        ? 'Saved as inactive, so it stays hidden from the marketplace. Turn it on from My Biz when you are ready to sell.'
        : 'Posted in $location. Buyers browsing $location see it first — switch your marketplace location if you do not spot it right away.';

    return Container(
      margin: const EdgeInsets.fromLTRB(30, 16, 30, 0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            isHidden ? LucideIcons.eyeOff : LucideIcons.mapPin,
            color: accent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: textColor.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              LucideIcons.bell,
              size: 48,
              color: textColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isBuyerRequest
                  ? 'We’ll notify you when an applicant is found'
                  : 'We’ll notify you when a buyer is found',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (widget.isBuyerRequest) {
                  Get.to(() => BossUpPartner());
                } else {
                  final ProfileController profileController = Get.find();
                  if (profileController.myProfile.isSubscribed) {
                    // They are Pro - in the future this should take them to the featuring flow
                    // For now, we show the Premium screen which explains the benefits
                    Get.to(ProshopdealsScreen());
                  } else {
                    // Not Pro -> Show Paywall
                    showPremiumPaywall();
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: primaryColorLT.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: primaryColorLT.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      widget.isBuyerRequest
                          ? LucideIcons.wallet
                          : LucideIcons.trendingUp,
                      color: primaryColorLT,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.isBuyerRequest
                            ? 'Save \ud83d\udcb0, claim partners deals'
                            : 'Get listing featured',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primaryColorLT,
                        ),
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight,
                        color: primaryColorLT, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            // Only the job path reaches here now — a listing shows the
            // "we'll notify you" state instead of a match list.
            'People who can help',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              final dynamic item = results[index];
              return _buildResultCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(dynamic item) {
    if (widget.isBuyerRequest) {
      final SuppliersModel supplier = item as SuppliersModel;
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundColor: primaryColorLT.withValues(alpha: 0.1),
            child: const Icon(LucideIcons.briefcase, color: primaryColorLT),
          ),
          title: Text(
            supplier.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            supplier.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12, color: textColor.withValues(alpha: 0.6)),
          ),
          trailing: const Icon(LucideIcons.chevronRight, size: 16),
          onTap: () {
            if (supplier.isBiz!) {
              Get.to(
                () => PublicProfileScreen(currentIndex: 1),
                arguments: supplier.user,
              );
            } else {
              Get.to(() => ExpandedSuppliersPage(supplier: supplier));
            }
          },
        ),
      );
    } else {
      final BuyerRequestModel request = item as BuyerRequestModel;
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            child: const Icon(LucideIcons.shoppingCart, color: Colors.orange),
          ),
          title: Text(
            request.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            request.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12, color: textColor.withValues(alpha: 0.6)),
          ),
          trailing: const Icon(LucideIcons.chevronRight, size: 16),
          onTap: () {
            RequestDetailsSheet.show(context, request);
          },
        ),
      );
    }
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ProCustomButton(
              text: 'Go Home',
              color: primaryColorLT,
              onPressed: () {
                Get.offAllNamed(Routes.marketPlace);
              },
            ),
          ),
        ],
      ),
    );
  }
}
