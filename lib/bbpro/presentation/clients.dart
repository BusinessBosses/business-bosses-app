import 'dart:async';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_supplier.dart';
import 'package:business_bosses_v2/bbpro/presentation/expandedprosupplierpage.dart';
import 'package:business_bosses_v2/bbpro/widgets/clientwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/customtabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/supplierscard.dart';
import 'package:business_bosses_v2/bbpro/widgets/topsection.dart';
import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/supplierspage.dart';
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
  Timer? _timer;
  bool? _lastMoveRight;
  late TabController _tabController;
  late TabController _viewController;
  bool loading = true;

  final ClientsController clientsController = Get.put(ClientsController());
  final ShopController shopController = Get.find();

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
    _tabController =
        TabController(length: ClientType.values.length, vsync: this);
    _viewController = TabController(length: 2, vsync: this);

    clientsController
        .initClients(clientsController.profileController.myProfile.uid)
        .then((_) {
      setState(() {
        loading = false;
      });
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
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.only(bottom: 5),
          width: 200,
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _viewController.index,
            children: const <int, Widget>{
              0: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text('Clients', style: TextStyle(fontSize: 14)),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text('Suppliers', style: TextStyle(fontSize: 14)),
              ),
            },
            onValueChanged: (int? value) {
              if (value != null) {
                setState(() {
                  _viewController.index = value;
                });
              }
            },
          ),
        ),
        actions: const <Widget>[NotificationButton()],
      ),
      body: TabBarView(controller: _viewController, children: <Widget>[
        Column(
          children: <Widget>[
            TopsectionWidget(
              buttonText: 'Add Client',
              onHowItWorksPressed: () {
                // Handle "How it works" pressed
                print('How it works pressed');
              },
              onAddProjectPressed: () {
                // Handle "Add Project" pressed
                Get.to(() => const Addclient());
              },
            ),
            CustomTabBarWidget<ClientType>(
              tabController: _tabController,
              scrollToSection: (int index) {
                _scrollToSection(index);
              },
              proprimaryColor: proprimaryColor,
              backgroundColor: backgroundColor,
              listofitems: ClientType.values.toList(),
              itemToString: (ClientType status) =>
                  '${status.displayTitle.toString().split('.').last} (${status == ClientType.allclients ? clientsController.clients.length : (clientsController.clientsType[status] == null ? '0' : clientsController.clientsType[status]!.length.toString())})',
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
                                  )
                                ],
                              ),
                      ),
              ),
            ),
          ],
        ),
        Column(children: <Widget>[
          TopsectionWidget(
            buttonText: 'Add Supplier',
            onHowItWorksPressed: () {
              // Handle "How it works" pressed
              print('How it works pressed');
            },
            onAddProjectPressed: () {
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
                          leading: const Icon(Icons.person_add),
                          title: const Text('Add a New Supplier'),
                          onTap: () {
                            Navigator.pop(context);
                            Get.to(() => const AddSupplier());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.file_upload),
                          title: const Text(
                              'Import Suppliers from Business Bosses'),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true, // Allow resizing
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return DraggableScrollableSheet(
                                  initialChildSize: 0.9, // 90% of the screen
                                  maxChildSize: 0.9,
                                  minChildSize: 0.9,
                                  expand: false,
                                  builder: (BuildContext context,
                                      ScrollController scrollController) {
                                    return const SizedBox.expand(
                                      // Ensures the content takes up the available space
                                      child: Center(
                                        child: Text('Supplier List here'),
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
            },
          ),
          Obx(() {
            if (shopController.suppliers.isNotEmpty) {
              return Expanded(
                child: StaggeredGridView.countBuilder(
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  itemCount: shopController.suppliers.length,
                  shrinkWrap: true,
                  physics: null,
                  itemBuilder: (BuildContext context, int index) {
                    return SuppliersCard(
                      onTap: () {
                        Get.to(() => ExpandedProSuppliersPage(
                            supplier: shopController.suppliers[index]));
                      },
                      supplier: shopController.suppliers[index],
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
      ]),
    );
  }

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
      case ClientType.bbUser:
        statusColor = primaryColorLT;
        break;
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
                            .withAlpha(100),
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
          bgcolor: clients[index].type.backgroundColor.withAlpha(100),
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
