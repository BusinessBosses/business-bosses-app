import 'dart:async';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/campaign_model.dart';
import 'package:business_bosses_v2/bbpro/models/supplier_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_supplier.dart';
import 'package:business_bosses_v2/bbpro/presentation/campaign_page.dart';
import 'package:business_bosses_v2/bbpro/presentation/expandedprosupplierpage.dart';
import 'package:business_bosses_v2/bbpro/widgets/campaign_item.dart';
import 'package:business_bosses_v2/bbpro/widgets/client_widget.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_tabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/supplierscard.dart';
import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen>
    with TickerProviderStateMixin {
  final ScrollController _mainListScrollController = ScrollController();
  final SupplierController supplierController = Get.put(SupplierController());
  Timer? _timer;
  bool? _lastMoveRight;
  late TabController _tabController;
  late TabController _viewController;
  bool loading = true;
  bool loadingSupplier = false;
  final ProfileController profileController = Get.find();

  final ClientsController clientsController = Get.put(ClientsController());
  final ShopController shopController = Get.find();

  String searchQuery = '';
  List<Campaign> filteredCampaign = <Campaign>[];

  void _scrollToSection(int index) {
    final double offset = index * MediaQuery.of(context).size.width * 0.9;
    _mainListScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    filteredCampaign.clear();
    _tabController =
        TabController(length: ClientType.values.length + 1, vsync: this);
    _viewController = TabController(length: 2, vsync: this);
    supplierController.initMySuppliers();
    supplierController.initSuppliers();
    clientsController.initClients(profileController.myProfile.uid).then((_) {
      clientsController.initCampaigns(profileController.myProfile.uid).then(
        (__) {
          setState(() {
            loading = false;
            filteredCampaign.addAll(clientsController.campaigns);
          });
        },
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewController.dispose();
    _mainListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // Dynamically build the children map based on the condition
    Map<int, Widget> segments = <int, Widget>{
      0: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Text(
          'Customers',
          style: _tabController.index == 0
              ? const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )
              : const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
        ),
      ),
      1: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Text(
          'Campaign',
          style: _tabController.index == 1
              ? const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )
              : const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
        ),
      ),
    };

    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.only(bottom: 5),
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _viewController.index,
            children: segments,
            onValueChanged: (int? value) {
              if (value != null) {
                setState(() {
                  _viewController.index = value;
                });
              }
            },
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String item) {
                  switch (item) {
                    case 'Item 1':
                      Get.to(() => const Addclient());
                      break;
                    case 'Item 2':
                      showModalBottomSheet<void>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/svgs/cors.svg',
                                    height: 18,
                                  ),
                                  title: const Text(
                                    'Add a New Supplier',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.to(() => const AddSupplier());
                                  },
                                ),
                                ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/svgs/import.svg',
                                    height: 16,
                                  ),
                                  title: const Text(
                                    'Import from Business Bosses',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled:
                                          true, // Allow resizing
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return DraggableScrollableSheet(
                                          initialChildSize:
                                              0.9, // 90% of the screen
                                          maxChildSize: 0.9,
                                          minChildSize: 0.9,
                                          expand: false,
                                          builder: (BuildContext context,
                                              ScrollController
                                                  scrollController) {
                                            return SizedBox.expand(
                                              // Ensures the content takes up the available space
                                              child: Obx(
                                                () =>
                                                    supplierController
                                                            .loading.value
                                                        ? const SafetyModel()
                                                        : supplierController
                                                                .suppliers
                                                                .isEmpty
                                                            ? const SafetyModel(
                                                                isLoading:
                                                                    false,
                                                                title:
                                                                    'No Supplier Found!',
                                                              )
                                                            : Column(
                                                                children: <Widget>[
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  const Text(
                                                                    'Select a Supplier',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        ListView(
                                                                      shrinkWrap:
                                                                          true,
                                                                      children: supplierController
                                                                          .suppliers
                                                                          .map((SuppliersModel supplier) => shopController.suppliers.any((Vendor element) => element.name == supplier.name)
                                                                              ? const SizedBox()
                                                                              : ListTile(
                                                                                  leading: (supplier.images != null && supplier.images!.isNotEmpty)
                                                                                      ? Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                          ),
                                                                                          child: ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                            child: Image.network(
                                                                                              supplier.images![0],
                                                                                              fit: BoxFit.cover,
                                                                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => const Icon(Icons.error),
                                                                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                                                if (loadingProgress == null) return child;
                                                                                                return const Center(child: CircularProgressIndicator());
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                  title: Text(supplier.name),
                                                                                  trailing: ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      Navigator.pop(context);
                                                                                      setState(() {
                                                                                        loadingSupplier = true;
                                                                                      });
                                                                                      Map<String, dynamic> supplierData = <String, dynamic>{
                                                                                        'userId': profileController.myProfile.uid,
                                                                                        'name': supplier.name,
                                                                                        'email': supplier.email,
                                                                                        'phone': supplier.phone,
                                                                                        'description': supplier.description,
                                                                                        'url': supplier.url,
                                                                                        'category': supplier.category,
                                                                                        'images': supplier.images,
                                                                                        'location': supplier.location,
                                                                                      };

                                                                                      try {
                                                                                        bool success = await shopController.addSupplier(supplierData);
                                                                                        if (success) {
                                                                                          showSnackbar(message: 'Supplier Added Successfully!');
                                                                                          await Future.delayed(const Duration(seconds: 1)); // Optional delay for visibility
                                                                                          // ignore: use_build_context_synchronously
                                                                                        } else {
                                                                                          showSnackbar(message: 'Error Adding Supplier!', error: true);
                                                                                        }
                                                                                      } catch (e) {
                                                                                        showSnackbar(message: 'An error occurred: $e', error: true);
                                                                                      } finally {
                                                                                        setState(() {
                                                                                          loadingSupplier = false;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: proprimaryColor,
                                                                                    ),
                                                                                    child: const Text('Select'),
                                                                                  ),
                                                                                ))
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      break;
                    case 'Item 3':
                      Get.to(() => const Campaignpage());
                      break;
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Item 1',
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/cors.svg',
                            colorFilter: const ColorFilter.mode(
                              textColor,
                              BlendMode.srcIn,
                            ),
                            height: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Add a Customer',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Item 2',
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/cors.svg',
                            height: 18,
                            colorFilter: const ColorFilter.mode(
                              textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Add a Supplier',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (profileController.myProfile.isSubscribed)
                      PopupMenuItem<String>(
                        value: 'Item 3',
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/megaphone.svg',
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Create a Campaign',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ];
                },
                offset: const Offset(50, 50),
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: proprimaryColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ChatScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: prosemibackColor,
                      child: SvgPicture.asset(
                        'assets/svgs/prochat.svg',
                        height: 15,
                      )),
                ),
              ),
              const NotificationButton(),
            ],
          )
        ],
      ),
      body: TabBarView(controller: _viewController, children: <Widget>[
        Column(
          children: <Widget>[
            // TopsectionWidget(
            //   buttonText: 'Add Client',
            //   onHowItWorksPressed: () {
            //     // Handle "How it works" pressed
            //     print('How it works pressed');
            //   },
            //   onAddProjectPressed: () {
            //     // Handle "Add Project" pressed
            //     Get.to(() => const Addclient());
            //   },
            // ),
            const SizedBox(
              height: 10,
            ),
            CustomTabBarWidget<String>(
              tabController: _tabController,
              scrollToSection: (int index) {
                _scrollToSection(index);
              },
              proprimaryColor: proprimaryColor,
              backgroundColor: <Color>[
                backgroundColor,
                Colors.green.withOpacity(0.1),
                Colors.blue.withOpacity(0.1),
                primaryColorLT.withOpacity(0.1),
              ],
              listofitems: <String>[
                ...ClientType.values.map((ClientType e) => e.name).toList(),
                'Suppliers',
              ],
              itemToString: (String status) {
                if (status == 'Suppliers') {
                  return 'Suppliers (${shopController.suppliers.length})';
                }
                final ClientType clientType = ClientType.values
                    .firstWhere((ClientType element) => element.name == status);
                return '${clientType.displayTitle.toString().split('.').last} (${clientType == ClientType.allclients ? clientsController.clients.length : (clientsController.clientsType[clientType] == null ? '0' : clientsController.clientsType[clientType]!.length.toString())})';
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Obx(
                        () => clientsController.clients.isEmpty
                            ? const Center(
                                child: SafetyModel(
                                  isLoading: false,
                                  title: 'No Clients Found!',
                                ),
                              )
                            : CustomScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _mainListScrollController,
                                slivers: <Widget>[
                                  ...ClientType.values.map(
                                    (ClientType status) => SliverToBoxAdapter(
                                      child: RowStatusCard(
                                        clients: clientsController.clients
                                            .where((Client client) =>
                                                client.type == status)
                                            .toList(),
                                        clientType: status,
                                        screenSize: screenSize,
                                        taskAccepted: (Client task,
                                            ClientType newStatus) {
                                          setState(() {
                                            // Update client status here
                                          });
                                        },
                                        onDrag: (bool isRight) {
                                          if (_lastMoveRight == isRight) {
                                            return;
                                          }
                                          _lastMoveRight = isRight;
                                          _moveMainList(isRight);
                                        },
                                        cancelDrag: () {
                                          _lastMoveRight = null;
                                          _timer?.cancel();
                                        },
                                        allclients: clientsController.clients,
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Container(
                                        width: screenSize.width * 0.9,
                                        height: screenSize.height * 0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(children: <Widget>[
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          primaryColorLT,
                                                      radius: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'Suppliers',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Divider(
                                              height: 1,
                                              color: Colors.black12,
                                            ),
                                          ),
                                          Obx(() {
                                            if (shopController
                                                .suppliers.isNotEmpty) {
                                              return loadingSupplier
                                                  ? const SafetyModel()
                                                  : Expanded(
                                                      child: StaggeredGridView
                                                          .countBuilder(
                                                        staggeredTileBuilder: (int
                                                                index) =>
                                                            const StaggeredTile
                                                                .fit(1),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 15.0,
                                                        ),
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 8.0,
                                                        mainAxisSpacing: 8.0,
                                                        itemCount:
                                                            shopController
                                                                .suppliers
                                                                .length,
                                                        shrinkWrap: true,
                                                        physics: null,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return SuppliersCard(
                                                            onTap: () {
                                                              Get.to(() => ExpandedProSuppliersPage(
                                                                  supplier: shopController
                                                                          .suppliers[
                                                                      index]));
                                                            },
                                                            supplier:
                                                                shopController
                                                                        .suppliers[
                                                                    index],
                                                          );
                                                        },
                                                      ),
                                                    );
                                            } else {
                                              return const Center(
                                                child: SafetyModel(
                                                  isLoading: false,
                                                  title: 'No Suppliers Found!',
                                                ),
                                              );
                                            }
                                          }),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
              ),
            ),
          ],
        ),
        Obx(
          () => clientsController.loading.value
              ? const SafetyModel()
              : profileController.myProfile.isSubscribed
                  ? clientsController.campaigns.isEmpty
                      ? SafetyModel(
                          isLoading: false,
                          icon: SvgPicture.asset(
                            'assets/svgs/campaign.svg',
                            height: 50,
                            color: Colors.black12,
                          ),
                          title: 'No Campaigns Yet!',
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 55,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10, bottom: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  'assets/svgs/search.svg',
                                                  height: 20,
                                                  color: hintColor,
                                                ),
                                                Expanded(
                                                  child: ProSearchbar(
                                                    contentPadding: 10,
                                                    hasSearchIcon: false,
                                                    hintText:
                                                        'Search Campaigns',
                                                    autofocus: false,
                                                    onChange: (String query) {
                                                      setState(() {
                                                        searchQuery = query;
                                                        filteredCampaign = clientsController
                                                            .campaigns
                                                            .where((Campaign
                                                                    campaign) =>
                                                                campaign
                                                                    .campaignName
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        searchQuery
                                                                            .toLowerCase()))
                                                            .toList();
                                                      });
                                                    },
                                                    onSubmit: (String query) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 0,
                                      bottom: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showMenu(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                context: context,
                                                shadowColor: Colors.black,
                                                position:
                                                    const RelativeRect.fromLTRB(
                                                        double.infinity,
                                                        130,
                                                        15,
                                                        0),
                                                items: <String>[
                                                  'None',
                                                  'Latest',
                                                  'A-Z'
                                                ].map((String option) {
                                                  return PopupMenuItem<String>(
                                                    value: option,
                                                    child: Text(option),
                                                  );
                                                }).toList());
                                          },
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: backgroundColor
                                                      .withOpacity(0.6),
                                                  offset: const Offset(-5, 0),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: SvgPicture.asset(
                                                  'assets/svgs/filterprosections.svg'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              filteredCampaign.isNotEmpty
                                  ? Expanded(
                                      child: ListView.builder(
                                        itemCount: filteredCampaign.length,
                                        itemBuilder:
                                            ((BuildContext context, int index) {
                                          return CampaignItem(
                                              campaign:
                                                  filteredCampaign[index]);
                                        }),
                                      ),
                                    )
                                  : const Text('No Campaigns found'),
                            ],
                          ),
                        )
                  : const PremiumScreen(),
        ),
      ]),
    );
  }
  // SuppliersModel? _selectedSupplier;

  // void _onItemSelect(bool? selected, SuppliersModel supplier) {
  //   setState(() {
  //     if (selected == true) {
  //       _selectedSupplier = supplier;
  //     } else {
  //       _selectedSupplier = null;
  //     }
  //   });
  // }

  void _moveMainList(bool isRight) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 100), () {
      if (_mainListScrollController.offset <= 20 && !isRight ||
          _mainListScrollController.offset >
              _mainListScrollController.position.maxScrollExtent) {
        _timer?.cancel();
        return;
      }
      _mainListScrollController.animateTo(
        _mainListScrollController.offset + (isRight ? 50 : -50),
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeIn,
      );
      _moveMainList(isRight);
    });
  }
}

class RowStatusCard extends StatefulWidget {
  final void Function(Client client, ClientType newStatus) taskAccepted;
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final ClientType clientType;
  final List<Client> clients;
  final Size screenSize;
  final List<Client> allclients;

  const RowStatusCard({
    required this.clients,
    required this.clientType,
    required this.screenSize,
    required this.taskAccepted,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
    required this.allclients,
  });

  @override
  State<RowStatusCard> createState() => _RowStatusCardState();
}

class _RowStatusCardState extends State<RowStatusCard> {
  bool _showSearchBar = false;
  List<Client> filteredClients = <Client>[];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredClients = widget.allclients;
  }

  @override
  Widget build(BuildContext context) {
    // Define color based on ClientType
    Color statusColor;
    switch (widget.clientType) {
      case ClientType.online:
        statusColor = Colors.green;
        break;
      case ClientType.inPerson:
        statusColor = Colors.blue;
        break;
      // case ClientType.bbUser:
      //   statusColor = primaryColorLT;
      //   break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      height: widget.screenSize.height * 0.8,
      width: widget.screenSize.width * 0.9,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    widget.clientType.displayTitle == 'All Clients'
                        ? Container()
                        : CircleAvatar(
                            backgroundColor: statusColor,
                            radius: 5,
                          ),
                    if (widget.clientType.displayTitle != 'all clients')
                      const SizedBox(width: 10),
                    Text(
                      widget.clientType.displayTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                if (widget.clientType.index != 0)
                  const SizedBox(
                    height: 31,
                  ),
                if (widget.clientType.index == 0)
                  _showSearchBar
                      ? Expanded(
                          child: SizedBox(
                            height: 31,
                            child: ProSearchbar(
                              contentPadding: 10,
                              backgroundColor: backgroundColor,
                              hasSearchIcon: false,
                              hintText: 'Search',
                              onChange: (String query) {
                                if (query.isEmpty) {}
                              },
                              onSubmit: (String query) {},
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSearchBar = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/svgs/search.svg',
                              height: 15,
                            ),
                          ),
                        ),
                if (widget.clientType.index == 0 && _showSearchBar)
                  const SizedBox(
                    width: 5,
                  ),
                if (widget.clientType.index == 0 && _showSearchBar)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSearchBar = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              color: Colors.black12,
            ),
          ),
          widget.clientType.index == 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: widget.allclients.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final ClientWidget clientWidget = ClientWidget(
                        client: widget.allclients[index],
                        bgcolor: widget.allclients[index].type.backgroundColor
                            .withOpacity(0.1),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: clientWidget,
                      );
                    },
                  ),
                )
              : Expanded(
                  child: ListStatusColumnWidget(
                    clients: widget.clients,
                    clientType: widget.clientType,
                  ),
                ),
        ],
      ),
    );
  }
}

class ListStatusColumnWidget extends StatelessWidget {
  final ClientType clientType;
  final List<Client> clients;

  const ListStatusColumnWidget({
    required this.clients,
    required this.clientType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: backgroundColor),
                borderRadius: BorderRadius.circular(radius)),
            child: const Center(
              child: Text(
                'Your Clients will show here',
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final ClientWidget clientWidget = ClientWidget(
          client: clients[index],
          bgcolor: clients[index].type.backgroundColor.withOpacity(0.1),
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: clientWidget,
        );
      },
      itemCount: clients.length,
    );
  }
}
