import 'dart:async';
import 'package:business_bosses_v2/bbpro/widgets/clientwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/customtabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/topsection.dart';
import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/addclient.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _mainListScrollController = ScrollController();
  Timer? _timer;
  bool? _lastMoveRight;
  late TabController _tabController;
  final List<Client> _allclients = <Client>[];

  final ClientsController clientsController = Get.put(ClientsController());
  final Map<ClientType, List<Client>> _clients = <ClientType, List<Client>>{};

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

    for (ClientType clientType in ClientType.values) {
      _clients[clientType] = <Client>[];
    }

    clientsController
        .initClients(clientsController.profileController.myProfile.uid)
        .then((_) {
      setState(() {
        for (ClientType clientType in ClientType.values) {
          List<Client> allclients = clientsController.clients
              .where((Client client) => client.type == clientType)
              .toList();
          _clients[clientType] = allclients;
          _allclients.addAll(allclients);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Clients',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const <Widget>[NotificationButton()],
      ),
      body: Column(
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
                '${status.displayTitle.toString().split('.').last} (${status == ClientType.allclients ? _allclients.length : _clients[status]!.length.toString()})',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Obx(() {
                if (clientsController.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!clientsController.loading.value &&
                    clientsController.clients.isEmpty) {
                  return const SafetyModel(
                    icon: Icon(Icons.warning),
                    title: 'No Clients Found!',
                  );
                }
                return CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _mainListScrollController,
                  slivers: <Widget>[
                    ...ClientType.values.map(
                      (ClientType status) => SliverToBoxAdapter(
                        child: RowStatusCard(
                          clients: clientsController.clients
                              .where((Client client) => client.type == status)
                              .toList(),
                          clientType: status,
                          screenSize: screenSize,
                          taskAccepted: (Client task, ClientType newStatus) {
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
                          allclients: _allclients,
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
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
        statusColor = Colors.blue;
        break;
      case ClientType.inPerson:
        statusColor = Colors.green;
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
                        bgcolor: widget.allclients[index].type.backgroundColor,
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
          bgcolor: clients[index].type.backgroundColor,
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
