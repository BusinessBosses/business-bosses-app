import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
// import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskitem.dart';
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
          'Create New Campaign',
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
          child: CustomTextWidget(
            padding: 15,
            textpadding: 15,
            hashint: true,
            caption: 'Select Customers *',
            iconName: 'assets/svgs/dropdown.svg',
            text: '',
            selectedarea: Column(
              children: selectedClientsName.map((String clientName) {
                return Taskitem(
                  isOrder: true,
                  taskname: clientName,
                  taskexpense: '',
                  deleteOnTap: () {
                    _removeClient(clientName);
                  },
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 15),
        CustomEditText(
          maxLength: 30,
          caption: 'Campaign Name',
          hintText: 'e.g. Black Friday Promotion ',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radiusValue),
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Add Image (Optional)',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.image),
                  ],
                ),
              ),
            ),
          ),
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
    final Map<String, dynamic>? client = clients.firstWhereOrNull(
      (Map<String, dynamic> client) => client['name'] == name,
    );

    if (client != null && !selectedClient.contains(client['id'])) {
      setState(() {
        selectedClient.add(client['id']);
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
    final Map<String, List<String>>? result =
        await showModalBottomSheet<Map<String, List<String>>>(
      // Changed return type
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
                    client['type'] == 'ClientType.online')
                .toList(),
            inperson: clients
                .where((Map<String, dynamic> client) =>
                    client['type'] == 'ClientType.inPerson')
                .toList(),
            bbuser: clients
                .where((Map<String, dynamic> client) =>
                    client['type'] == 'ClientType.bbUser')
                .toList(),
            all: clients,
            selectedName: selectedClientsName,
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedClient = result['ids'] ?? <String>[];
        selectedClientsName = result['names'] ?? <String>[];
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final ShopController shopController = Get.find();

  List<Map<String, dynamic>>? selectedItems = <Map<String, dynamic>>[];

  String _allSearchQuery = '';
  List<String> selectedItem = <String>[];

  List<String> selectedNames = <String>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      setState(() {});
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
                'Select Customer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(children: <Widget>[
                ProIconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    // ignore: always_specify_types
                    Navigator.pop(context, {
                      'ids': selectedItem,
                      'names': selectedNames,
                    });
                  },
                  text: 'Done',
                  radius: 10.0,
                ),
              ])
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildClientList(widget.all, _allSearchQuery, (String query) {
                  setState(() {
                    _allSearchQuery = query;
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

    bool selectAll = filteredClients.length == selectedItem.length;

    return Column(
      children: <Widget>[
        ProSearchbar(
          hasSearchIcon: true,
          contentPadding: 10,
          backgroundColor: backgroundColor,
          hintText: 'Search Customer',
          onChange: onSearchChange,
          onSubmit: (String query) {},
        ),
        const SizedBox(height: 10),
        CheckboxListTile(
          title: const Text('Select all customers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          value: selectAll,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedItem = filteredClients
                    .map(
                        (Map<String, dynamic> client) => client['id'] as String)
                    .toList();
                selectedNames = filteredClients
                    .map((Map<String, dynamic> client) =>
                        client['name'] as String)
                    .toList();
              } else {
                selectedItem.clear();
                selectedNames.clear();
              }
            });
          },
        ),
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
                                selectedNames.add(client['name']);
                              } else {
                                selectedItem.remove(client['id']);
                                selectedNames.remove(client['name']);
                              }
                            });
                          },
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
