import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
// import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Campaignpage extends StatefulWidget {
  const Campaignpage({super.key});

  @override
  State<Campaignpage> createState() => _CampaignpageState();
}

class _CampaignpageState extends State<Campaignpage> {
  bool isSubmit = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<String> selectedClient = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];
  List<String> clientsName = <String>[];
  List<String> selectedClientsName = <String>[];
  final ClientsController clientsController = Get.put(ClientsController());
  String? clientId;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        _loadClients();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Create Campaign',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            _showClientSheet(context);
          },
          child: const CustomTextWidget(
            padding: 15,
            textpadding: 15,
            hashint: true,
            caption: 'Client\'s Name *',
            iconName: 'assets/svgs/dropdown.svg',
            text: 'Select Customers',
          ),
        ),
        const SizedBox(height: 15),
        if (clientsName.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectedClientsName.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(selectedClientsName[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    _removeClient(clientsName[index]);
                  },
                ),
              );
            },
          ),
        CustomEditText(
          maxLength: 30,
          caption: 'Campaign Name',
          hintText: 'Eg Black Friday Promotion ',
          controller: nameController,
        ),
        const SizedBox(
          height: 15,
        ),
        CustomEditText(
          caption: 'Message',
          hintText: 'Enter Campaign message / content',
          controller: notesController,
          maxLength: 300,
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ProCustomButton(
            loading: isSubmit,
            text: 'Send Campaign',
            onPressed: () async {
              final bool? result = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm Submission'),
                  content: const Text(
                      'Are you sure you want to send this campaign?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );
              if (result == true) {
                setState(() {
                  isSubmit = true;
                });
                final Map<String, dynamic> data = <String, dynamic>{
                  'clientIds': selectedClient,
                  'campaignName': nameController.text,
                  'message': notesController.text,
                };
                final bool response =
                    await clientsController.sendCampaign(data);
                if (response) {
                  showSnackbar(message: 'Campaign Sent Successfully!');
                  Navigator.pop(context);
                } else {
                  showSnackbar(message: 'Error sending campaign!', error: true);
                  setState(() {
                    isSubmit = false;
                  });
                }
              }
            },
          ),
        ),
        const SizedBox(height: 100),
      ]),
    );
  }

  void _loadClients() {
    if (clientsController.clients.isNotEmpty) {
      setState(() {
        clients = clientsController.clients
            .map((Client client) => <String, dynamic>{
                  'name': client.name,
                  'id': client.id,
                  'type': client.type,
                })
            .toList();
        clientsName = clients
            .map((Map<String, dynamic> client) => client['name'] as String)
            .toList();
      });
    }
  }

  void _onClientSelect(String name) {
    final Map<String, dynamic> clientName = clients
        .firstWhere((Map<String, dynamic> client) => client['name'] == name);
    if (!selectedClient.contains(clientName['id'])) {
      setState(() {
        selectedClient.add(clientName['id']);
        selectedClientsName.add(name);
      });
    }
  }

  void _removeClient(String name) {
    final Map<String, dynamic> client = clients.firstWhere(
      (Map<String, dynamic> element) => element['name'] == name,
      orElse: () => <String, dynamic>{},
    );

    setState(() {
      selectedClientsName.remove(name);
      selectedClient.remove(client['id']);
    });
  }

  void _showClientSheet(BuildContext context) async {
    final String? result = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: ChooseClientsBottomSheet(
            isCampaign: true,
            onClientAdded: () {
              _loadClients();
            },
            selectedItem: selectedClient,
            online: clients
                .where((Map<String, dynamic> client) =>
                    client['type'].toString() == 'ClientType.online')
                .toList(),
            inperson: clients
                .where((Map<String, dynamic> client) =>
                    client['type'].toString() == 'ClientType.inPerson')
                .toList(),
            bbuser: clients
                .where((Map<String, dynamic> client) =>
                    client['type'].toString() == 'ClientType.bbUser')
                .toList(),
            all: clients,
            selectedName: selectedClientsName,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _onClientSelect(result); // Update clientId based on selected client
      });
    }
  }
}

class ChooseClientsBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> online;
  final List<Map<String, dynamic>> inperson;
  final List<Map<String, dynamic>> bbuser;
  final List<Map<String, dynamic>> all;
  final List<String> selectedItem;
  final List<String> selectedName;
  final VoidCallback? onClientAdded;
  final bool? isCampaign;

  const ChooseClientsBottomSheet({
    Key? key,
    required this.selectedItem,
    required this.selectedName,
    required this.online,
    required this.inperson,
    required this.bbuser,
    this.onClientAdded,
    required this.all,
    this.isCampaign,
  }) : super(key: key);

  @override
  State<ChooseClientsBottomSheet> createState() =>
      _ChooseClientBottomSheetState();
}

class _ChooseClientBottomSheetState extends State<ChooseClientsBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final ShopController shopController = Get.find();

  List<Map<String, dynamic>>? selectedItems = <Map<String, dynamic>>[];

  String _onlineSearchQuery = '';
  String _allSearchQuery = '';
  String _inpersonSearchQuery = '';
  String _bbuserSearchQuery = '';
  List<String> selectedItem = <String>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    currencyController.text = shopController.shop!.currency;
    selectedItem =
        widget.selectedItem; // Initialize with widget's selected item
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Select Client',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(children: <Widget>[
                ProIconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Get.back();
                    // Get.to(Addclient(
                    //   onClientAdded: widget.onClientAdded,
                    // ));
                  },
                  text: 'Done',
                  radius: 10.0,
                ),
              ])
            ],
          ),
          const SizedBox(height: 10),
          if (widget.isCampaign == null)
            CupertinoSlidingSegmentedControl<int>(
              backgroundColor: probackgroundColor,
              groupValue: _selectedIndex,
              children: const <int, Widget>{
                0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                      'All',
                      style: TextStyle(fontSize: 14),
                    )),
                1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                      'Online',
                      style: TextStyle(fontSize: 14),
                    )),
                2: Text(
                  'In-person',
                  style: TextStyle(fontSize: 14),
                ),
                3: Text(
                  'BB-User',
                  style: TextStyle(fontSize: 14),
                ),
              },
              onValueChanged: (int? value) {
                setState(() {
                  _selectedIndex = value!;
                  _tabController.animateTo(value);
                });
              },
            ),
          if (widget.isCampaign == null) const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildClientList(widget.all, _allSearchQuery, (String query) {
                  setState(() {
                    _allSearchQuery = query;
                  });
                }),
                if (widget.isCampaign == null)
                  _buildClientList(widget.online, _onlineSearchQuery,
                      (String query) {
                    setState(() {
                      _onlineSearchQuery = query;
                    });
                  }),
                if (widget.isCampaign == null)
                  _buildClientList(widget.inperson, _inpersonSearchQuery,
                      (String query) {
                    setState(() {
                      _inpersonSearchQuery = query;
                    });
                  }),
                if (widget.isCampaign == null)
                  _buildClientList(widget.bbuser, _bbuserSearchQuery,
                      (String query) {
                    setState(() {
                      _bbuserSearchQuery = query;
                    });
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList(List<Map<String, dynamic>> clients,
      String searchQuery, Function(String) onSearchChange) {
    final List<Map<String, dynamic>> filteredClients = clients
        .where((Map<String, dynamic> client) =>
            client['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: <Widget>[
        ProSearchbar(
          hasSearchIcon: true,
          contentPadding: 10,
          backgroundColor: backgroundColor,
          hintText: 'Search Clients',
          onChange: onSearchChange,
          onSubmit: (String query) {},
        ),
        const SizedBox(height: 10),
        Expanded(
          child: filteredClients.isNotEmpty
              ? ListView(
                  children: filteredClients.map((Map<String, dynamic> client) {
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text(client['name']),
                          value: selectedItem.contains(client['id']),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedItem.add(client['id']);
                                widget.selectedName.add(client['name']);
                              } else {
                                selectedItem.remove(client['id']);
                                widget.selectedName.remove(client['name']);
                              }
                            });
                          },
                        ),
                        if (selectedItem == client['name'])
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ProIconButton(
                              onPressed: () {
                                Navigator.pop(context, selectedItem);
                              },
                              text: 'Done',
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                )
              : const Text(
                  'No search results',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
        ),
      ],
    );
  }
}
