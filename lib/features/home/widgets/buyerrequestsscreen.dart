import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/home/widgets/buyerrequestitem.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Import your other files (buyer_request_item.dart and request_form.dart)
// For this example, I'm including the necessary classes here

class BuyerRequest {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? budget;
  final String? location;
  final DateTime? deadline;
  final List<PlatformFile> attachments;
  final DateTime createdAt;
  final int offerCount;
  final String? imageUrl;

  BuyerRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.budget,
    this.location,
    this.deadline,
    this.attachments = const <PlatformFile>[],
    required this.createdAt,
    this.offerCount = 0,
    this.imageUrl,
  });
}

class BuyerRequestsScreen extends StatefulWidget {
  const BuyerRequestsScreen({super.key});

  @override
  State<BuyerRequestsScreen> createState() => _BuyerRequestsScreenState();
}

class _BuyerRequestsScreenState extends State<BuyerRequestsScreen> {
  final String _selectedFilter = 'All';
  final List<String> _filters = <String>[
    'All',
    'Active',
    'Has Offers',
    'Closing Soon'
  ];

  // Dummy data
  late List<BuyerRequest> _allRequests;
  List<BuyerRequest> _filteredRequests = <BuyerRequest>[];

  @override
  void initState() {
    super.initState();
    _initializeDummyData();
    _applyFilter();
  }

  void _initializeDummyData() {
    _allRequests = <BuyerRequest>[
      BuyerRequest(
        id: '1',
        title: 'Need a responsive website for my startup',
        description:
            'Looking for an experienced web developer to build a modern, responsive website for my tech startup. The site should have a landing page, about us section, services page, and contact form. Must be mobile-friendly and SEO optimized.',
        category: 'Web Development',
        budget: '\$5,000 - \$10,000',
        deadline: DateTime.now().add(const Duration(days: 15)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        location: 'Ghana',
        offerCount: 12,
        imageUrl:
            'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '2',
        title: 'iOS and Android app development',
        description:
            'Need a cross-platform mobile app for food delivery service. Should include user authentication, real-time order tracking, payment integration, and push notifications. Looking for Flutter or React Native developers.',
        category: 'Mobile Development',
        budget: '\$15,000 - \$25,000',
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        offerCount: 8,
        imageUrl:
            'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '3',
        title: 'Logo design for new coffee brand',
        description:
            'Seeking a creative designer to create a unique and memorable logo for our new coffee brand. We want something modern, clean, and that reflects artisanal quality. Need multiple concepts and revisions included.',
        category: 'Design & Creative',
        budget: '\$500 - \$1,000',
        deadline: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        offerCount: 24,
        imageUrl:
            'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '4',
        title: 'Content writer for tech blog',
        description:
            'Looking for an experienced tech writer to produce 10 high-quality blog posts about AI, machine learning, and emerging technologies. Each post should be 1,500-2,000 words, well-researched, and SEO optimized.',
        category: 'Writing & Translation',
        budget: '\$1,500 - \$2,500',
        deadline: DateTime.now().add(const Duration(days: 20)),
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        offerCount: 15,
        imageUrl:
            'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '5',
        title: 'Social media marketing campaign',
        description:
            'Need a digital marketing expert to create and execute a 3-month social media campaign across Instagram, Facebook, and TikTok. Must include content strategy, post creation, and performance analytics.',
        category: 'Marketing & Sales',
        budget: '\$3,000 - \$5,000',
        deadline: DateTime.now().add(const Duration(days: 10)),
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        offerCount: 6,
        imageUrl:
            'https://images.unsplash.com/photo-1432888622747-4eb9a8efeb07?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '6',
        title: 'Business plan for tech startup',
        description:
            'Seeking an experienced business consultant to help develop a comprehensive business plan for our SaaS startup. Need market analysis, financial projections, and go-to-market strategy.',
        category: 'Business Consulting',
        budget: '\$2,000 - \$4,000',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        offerCount: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '7',
        title: 'Data analysis and visualization',
        description:
            'Need help analyzing sales data and creating interactive dashboards. Must be proficient in Python, pandas, and visualization tools like Tableau or Power BI. Dataset includes 2 years of transaction history.',
        category: 'Data & Analytics',
        budget: '\$1,000 - \$2,000',
        deadline: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        offerCount: 9,
        imageUrl:
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '8',
        title: 'Video editing for YouTube channel',
        description:
            'Looking for a skilled video editor for our educational YouTube channel. Need someone who can edit 4 videos per month with engaging transitions, graphics, and sound effects. Experience with educational content preferred.',
        category: 'Design & Creative',
        budget: '\$800 - \$1,200',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        offerCount: 0,
        imageUrl:
            'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '9',
        title: 'E-commerce website with payment integration',
        description:
            'Need a full-featured e-commerce website built on Shopify or WooCommerce. Must include product catalog, shopping cart, payment gateway integration, and inventory management. About 100 products initially.',
        category: 'Web Development',
        budget: '\$8,000 - \$12,000',
        deadline: DateTime.now().add(const Duration(days: 25)),
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        offerCount: 11,
        imageUrl:
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=300&fit=crop',
      ),
      BuyerRequest(
        id: '10',
        title: 'Legal contract review and drafting',
        description:
            'Seeking a business attorney to review and draft service agreements for our consulting firm. Need template contracts for different service tiers and NDA templates. Must be compliant with US business law.',
        category: 'Legal Services',
        budget: '\$1,500 - \$2,500',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        offerCount: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&h=300&fit=crop',
      ),
    ];
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == 'All') {
        _filteredRequests = List.from(_allRequests);
      } else if (_selectedFilter == 'Active') {
        _filteredRequests = _allRequests
            .where(
                (BuyerRequest r) => r.deadline?.isAfter(DateTime.now()) ?? true)
            .toList();
      } else if (_selectedFilter == 'Has Offers') {
        _filteredRequests =
            _allRequests.where((BuyerRequest r) => r.offerCount > 0).toList();
      } else if (_selectedFilter == 'Closing Soon') {
        _filteredRequests = _allRequests
            .where((BuyerRequest r) =>
                r.deadline != null &&
                r.deadline!.difference(DateTime.now()).inDays <= 7)
            .toList();
      }
    });
  }

  void _navigateToChatScreen(BuyerRequest request) {
    Get.to(ChatRoomScreen(frommarketplace: false));
  }

  void _showRequestDetails(BuyerRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(Routes.publicProfile,
                      //     arguments: widget.request.user);
                    },
                    child: Row(
                      spacing: 10,
                      children: <Widget>[
                        NetworkImageWithPlaceHolder(
                          imageUrl: '',
                          height: 40,
                          width: 40,
                          radius: 50,
                          cacheHeight: 256,
                          cacheWidth: 256,
                          placeHolder: Icons.person,
                          iconSize: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Image section
                  if (request.imageUrl != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(request.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  if (request.imageUrl != null) const SizedBox(height: 16),

                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (request.budget != null) ...<Widget>[
                    _buildDetailRow(
                        Icons.attach_money, 'Budget', request.budget!),
                    const SizedBox(height: 12),
                  ],
                  if (request.deadline != null) ...<Widget>[
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Deadline',
                      DateFormat('MMMM dd, yyyy').format(request.deadline!),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _buildDetailRow(Icons.category, 'Category', request.category),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.local_offer,
                    'Offers Received',
                    request.offerCount.toString(),
                  ),
                  const SizedBox(height: 32),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _navigateToChatScreen(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Send Proposal',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: <Widget>[
          // Requests List
          Expanded(
            child: _filteredRequests.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        _applyFilter();
                      });
                    },
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 100),
                      itemCount: _filteredRequests.length,
                      itemBuilder: (BuildContext context, int index) {
                        final BuyerRequest request = _filteredRequests[index];
                        return BuyerRequestItem(
                          request: request,
                          onApply: () => _navigateToChatScreen(request),
                          onTap: () {
                            _showRequestDetails(request);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No requests found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
