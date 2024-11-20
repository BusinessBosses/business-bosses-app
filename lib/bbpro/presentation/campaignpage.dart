import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/chooseclientbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
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
  String? selectedClient;
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];
  List<String> clientsName = <String>[];
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
          child: CustomTextWidget(
            padding: 15,
            textpadding: 15,
            hashint: true,
            caption: 'Client\'s Name *',
            iconName: 'assets/svgs/dropdown.svg',
            text: selectedClient ?? 'Select Customers',
          ),
        ),
        const SizedBox(
          height: 15,
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
            onPressed: () async {},
          ),
        ),
        const SizedBox(height: 100),
      ]),
    );
  }

  void _loadClients() {
    clients.clear();
    clientsName.clear();
    for (Client client in clientsController.clients) {
      clientsName.add(client.name);
      clients.add(<String, dynamic>{
        'name': client.name,
        'id': client.id,
        'type': client.type
      });
    }
  }

  void _onClientSelect(String name) {
    final dynamic clientName = clients
        .firstWhere((Map<String, dynamic> element) => element['name'] == name);
    setState(() {
      clientId = clientName['id'];
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
          child: ChooseClientBottomSheet(
            isCampaign: true,
            onClientAdded: () {
              _loadClients();
            },
            selectedItem: selectedClient ?? '',
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
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectedClient = result;
        _onClientSelect(result); // Update clientId based on selected client
      });
    }
  }
}
