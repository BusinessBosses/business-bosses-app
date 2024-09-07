import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool loading = false;

  String selectedClient = 'Online';
  String selectedOrder = 'Online';
  String selectedOrderChannel = 'Online';
  String selectedClientType = 'Online';
  String selectedDeliveryMethod = 'Courier';
  String selectedOrderDate = 'Select Date';
  String selectedPaymentMethod = 'Bank';

  List<String> clients = <String>[];

  // GetX Controller
  final OrderController orderController = Get.find();
  final ProfileController profileController = Get.find();
  final ClientsController clientsController = Get.put(ClientsController());

  // Sample product and service lists
  final List<Map<String, dynamic>> products = <Map<String, dynamic>>[
    <String, dynamic>{'type': 'product', 'id': 1, 'name': 'Product 1'},
    <String, dynamic>{'type': 'product', 'id': 2, 'name': 'Product 2'},
    <String, dynamic>{'type': 'product', 'id': 3, 'name': 'Product 3'},
  ];

  final List<Map<String, dynamic>> services = <Map<String, dynamic>>[
    <String, dynamic>{'type': 'service', 'id': 1, 'name': 'Service 1'},
    <String, dynamic>{'type': 'service', 'id': 2, 'name': 'Service 2'},
  ];

  List<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[];

  void _submitOrder() {
    final Map<String, dynamic> orderData = <String, dynamic>{
      'userId': profileController.myProfile.uid,
      'shopId': 'c215b1f3-4465-4f48-a97e-742802d9d0d4',
      'clientId': selectedClient,
      'items': selectedItems,
      'deliveryMethod': selectedDeliveryMethod,
      'deliveryDate': selectedOrderDate,
      'paymentMethod': selectedPaymentMethod,
      'notes': notesController.text,
      'invoiceOption': 'send_with_payment_link'
    };

    // Call the addOrder method from the GetX controller
    orderController.addOrders(orderData);
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        for (Client client in clientsController.clients) {
          clients.add(client.name);
        }
        loading = false; // Update the loading state
      });
    }
  }

  void _onItemSelect(bool? selected, Map<String, dynamic> item) {
    setState(() {
      if (selected!) {
        selectedItems.add(item);
      } else {
        selectedItems.removeWhere(
            (Map<String, dynamic> element) => element['id'] == item['id']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create New Order',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false, // Removes back button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Client\'s Name',
                          items: clients,
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedClient,
                          onChanged: (String? value) {
                            setState(() {
                              selectedClient = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Choose Order',
                          items: const <String>['Online', 'Offline'],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedOrder,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOrder = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Order Channel',
                          items: const <String>['Online', 'Offline'],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedOrderChannel,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOrderChannel = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomTextWidget(
                            caption: 'Order Date',
                            iconName: 'assets/svgs/calendar.svg',
                            text: selectedOrderDate,
                            textpadding: 15,
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Payment Method',
                          items: const <String>[
                            'Bank',
                            'Paypal',
                            'Wallet',
                            'Cash'
                          ],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedPaymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Client Type',
                          items: const <String>['Online', 'Offline'],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedClientType,
                          onChanged: (String? value) {
                            setState(() {
                              selectedClientType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Delivery Method',
                          items: const <String>['Courier', 'Pickup'],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedDeliveryMethod,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDeliveryMethod = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        // Products Selection
                        const Text('Select Products:'),
                        Column(
                          children:
                              products.map((Map<String, dynamic> product) {
                            return CheckboxListTile(
                              title: Text(product['name']),
                              value: selectedItems.contains(product),
                              onChanged: (bool? selected) {
                                _onItemSelect(selected, product);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 15),
                        // Services Selection
                        const Text('Select Services:'),
                        Column(
                          children:
                              services.map((Map<String, dynamic> service) {
                            return CheckboxListTile(
                              title: Text(service['name']),
                              value: selectedItems.contains(service),
                              onChanged: (bool? selected) {
                                _onItemSelect(selected, service);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 15),
                        CustomEditText(
                          caption: 'Notes',
                          hintText: 'Add order notes here',
                          controller: notesController,
                          maxLength: 300,
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ProCustomButton(
                      text: 'Create',
                      onPressed: _submitOrder,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
