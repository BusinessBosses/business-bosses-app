import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ListingSuccessScreen extends StatefulWidget {
  final bool isBuyerRequest;
  final String industry;
  final String location;
  final String? productId;
  final String? serviceId;

  const ListingSuccessScreen({
    super.key,
    required this.isBuyerRequest,
    required this.industry,
    required this.location,
    this.productId,
    this.serviceId,
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
      // Show buyer requests in their industry/location
      results =
          buyerRequestController.buyerRequests.where((BuyerRequestModel r) {
        final bool matchIndustry = r.category.toLowerCase().trim() ==
            widget.industry.toLowerCase().trim();
        final bool matchLocation = r.user.location?.toLowerCase().trim() ==
            widget.location.toLowerCase().trim();
        return matchIndustry && matchLocation;
      }).toList();
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
          widget.isBuyerRequest ? 'Request Posted!' : 'Listing Created!',
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
                ? 'Your request is now live. Here are some suppliers who can help.'
                : 'Your listing is now live. Here are some buyers looking for what you offer.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
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
              LucideIcons.searchX,
              size: 48,
              color: textColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isBuyerRequest
                  ? 'We’ll notify you when a supplier is found'
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
                    Get.bottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.9,
                        child: const Scaffold(
                          backgroundColor: Colors.white,
                          body: SafeArea(
                            child:
                                SingleChildScrollView(child: PremiumScreen()),
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  } else {
                    // Not Pro -> Redirect to Upgrade Screen
                    Get.to(() => const Scaffold(
                          backgroundColor: Colors.white,
                          body: SafeArea(
                            child:
                                SingleChildScrollView(child: PremiumScreen()),
                          ),
                        ));
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
            widget.isBuyerRequest
                ? 'Matching Suppliers'
                : 'Matching Buyer Requests',
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
            // Navigate to supplier profile if needed
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
            // Navigate to request details if needed
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
                Get.to(() => HomeScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}
