import 'dart:async';

import 'package:business_bosses_v2/bbpro/common/widgets/clientwidget.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/topsection.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/addclient.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ScrollController _mainListScrollController = ScrollController();
  Timer? _timer;
  bool? _lastMoveRight;
  final Map<ClientType, List<Client>> _clients = <ClientType, List<Client>>{};
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
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 15),
              child: CircleAvatar(
                backgroundColor: prosemibackColor,
                radius: 30, // This sets the circle's radius
                child: Padding(
                  padding: const EdgeInsets.all(
                      10), // Adjust padding to fit the icon nicely
                  child: SvgPicture.asset(
                    'assets/svgs/notificationicon.svg',
                    height: 20,
                  ),
                ),
              ),
            )
          ],
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
                Get.to(const Addclient());
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _mainListScrollController,
                  slivers: <Widget>[
                    ...ClientType.values.map(
                      (ClientType status) => SliverToBoxAdapter(
                        child: RowStatusCard(
                          clients: _clients[status] ?? <Client>[],
                          clientType: status,
                          screenSize: screenSize,
                          taskAccepted: (Client task, ClientType newStatus) {
                            setState(() {
                              // _clients[task.status]?.remove(task);
                              // _clients[newStatus]?.add(
                              //   Client(

                              //   ),
                              // );
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
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

class RowStatusCard extends StatelessWidget {
  final void Function(Client client, ClientType newStatus) taskAccepted;
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final ClientType clientType;
  final List<Client> clients;
  final Size screenSize;

  const RowStatusCard({
    required this.clients,
    required this.clientType,
    required this.screenSize,
    required this.taskAccepted,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.8,
      width: screenSize.width * 0.9,
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
                    CircleAvatar(
                      backgroundColor: clientType.displayTitle == 'On-line'
                          ? Colors.black
                          : ClientType == 'In-person'
                              ? Colors.amber
                              : Colors.green,
                      radius: 5,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      clientType.displayTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/svgs/search.svg',
                      height: 20,
                    ),
                  ),
                )
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
          Expanded(
            child: ListStatusColumnWidget(
              clients: clients,
              Clienttype: clientType,
            ),
          ),
        ],
      ),
    );
  }
}

class ListStatusColumnWidget extends StatelessWidget {
  final ClientType Clienttype;
  final List<Client> clients;

  const ListStatusColumnWidget({
    required this.clients,
    required this.Clienttype,
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
            padding: const EdgeInsets.only(bottom: 12), child: clientWidget);
      },
      itemCount: clients.length,
    );
  }
}
