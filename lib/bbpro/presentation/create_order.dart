// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/chooseclientbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/widgets/chooseorderbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/invoiceoptionswidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskitem.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrder extends StatefulWidget {
  final Order? order;
  const CreateOrder({super.key, this.order});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final TextEditingController notesController = TextEditingController();

  bool loading = false;

  String? selectedClient;
  String selectedOrder = '';
  String selectedOrderChannel = '';
  String selectedClientType = '';
  String? selectedDeliveryMethod;
  String? initialDeliveryMethod;
  String? selectedOrderDate;
  String? selectedPaymentMethod;
  String? clientId;
  bool canAdd = true;
  List<String> paymentMethod = <String>[];
  bool isSubmit = false;

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];

  // GetX Controller
  final OrderController orderController = Get.find();
  final ProfileController profileController = Get.find();
  final ClientsController clientsController = Get.put(ClientsController());
  final ShopController shopController = Get.find();

  // Sample product and service lists
  final List<Map<String, dynamic>> products = <Map<String, dynamic>>[];

  final List<Map<String, dynamic>> services = <Map<String, dynamic>>[];

  List<Map<String, dynamic>>? selectedItems = <Map<String, dynamic>>[];

  void _showOrderSheet(BuildContext context) async {
    final List<Map<String, dynamic>>? result =
        await showModalBottomSheet<List<Map<String, dynamic>>>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      // isDismissible: false,
      // enableDrag: false,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: ChooseOrderBottomSheet(
            products: products,
            services: services,
            selectedItems: selectedItems ?? <Map<String, dynamic>>[],
            onCanAddChange: (bool value) {
              setState(() {
                canAdd = value; // Updates the parent widget's `canAdd` field
              });
            },
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectedItems = result;
        // Update clientId based on selected client
      });
    }
  }

  final List<Map<String, dynamic>> online = <Map<String, dynamic>>[];

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

  void _submitOrder() async {
    if (clientId == null) {
      showSnackbar(message: 'Please select a valid client', error: true);
      return;
    } else if (selectedItems!.isEmpty) {
      showSnackbar(message: 'Please select an item', error: true);
      return;
    } else if (selectedDeliveryMethod == null) {
      showSnackbar(message: 'Please select a delivery method', error: true);
      return;
    } else if (selectedOrderDate == null) {
      showSnackbar(message: 'Please select a date!', error: true);
      return;
    } else if (selectedPaymentMethod == null) {
      showSnackbar(message: 'Please select a payment method', error: true);
      return;
    }
    setState(() {
      isSubmit = true;
    });
    final Map<String, dynamic> orderData = <String, dynamic>{
      'userId': profileController.myProfile.uid,
      'shopId': shopController.shop?.id,
      'clientId': clientId,
      'items': selectedItems,
      'deliveryMethod': selectedDeliveryMethod,
      'deliveryDate': selectedOrderDate,
      'paymentMethod': selectedPaymentMethod,
      'notes': notesController.text,
      'invoiceOption': 'send_with_payment_link'
    };
    bool response;
    // Call the addOrder method from the GetX controller
    if (widget.order != null) {
      response = await orderController.updateOrder(widget.order!.id, orderData);
    } else {
      response = await orderController.addOrders(orderData);
    }
    if (response) {
      showSnackbar(
          message: widget.order != null
              ? 'Order Updated Successfully'
              : 'Order Added Successfully!');
      await orderController.initOrders(profileController.myProfile.uid);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      showSnackbar(
          message: widget.order != null
              ? 'Error Updating Order!'
              : 'Error creating order!',
          error: true);
      setState(() {
        isSubmit = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        _loadClients();

        for (Product product in shopController.products) {
          products.add(
            <String, dynamic>{
              'type': 'product',
              'id': product.id,
              'name': product.name,
              'price': product.price.toString(),
              'images': product.images![0],
            },
          );
        }
        for (Service service in shopController.services) {
          services.add(
            <String, dynamic>{
              'type': 'service',
              'id': service.id,
              'name': service.name,
              'price': service.price.toString()
            },
          );
        }

        for (dynamic payments in shopController.shop!.payments) {
          paymentMethod.add(payments['paymentMethod']);
        }
        loading = false; // Update the loading state
      });
    }
    if (widget.order != null) {
      notesController.text = widget.order!.notes;
      clientId = widget.order!.clientId;
      selectedClient = clients.firstWhere(
        (Map<String, dynamic> element) => element['id'] == clientId,
        orElse: () => <String, dynamic>{
          'name': ''
        }, // Provide a default value if no match is found
      )['name'];
      selectedDeliveryMethod = widget.order!.deliveryMethod;
      if (widget.order!.deliveryMethod == 'online') {
        initialDeliveryMethod = 'Online';
      } else {
        initialDeliveryMethod = 'In-Person';
      }
      selectedOrderDate = widget.order!.deliveryDate.toString();
      selectedPaymentMethod = widget.order!.paymentMethod;
      if (widget.order!.services != null) {
        for (Service service1 in widget.order!.services!) {
          selectedItems!.add(
            <String, dynamic>{
              'type': 'service',
              'id': service1.id,
              'name': service1.name,
              'price': service1.price.toString()
            },
          );
        }
      }

      if (widget.order!.products != null) {
        for (Product product1 in widget.order!.products!) {
          selectedItems!.add(
            <String, dynamic>{
              'type': 'service',
              'id': product1.id,
              'name': product1.name,
              'price': product1.price.toString()
            },
          );
        }
      }

      if (widget.order!.customItems != null) {
        for (dynamic custom in widget.order!.customItems!) {
          selectedItems!.add(
            <String, dynamic>{
              'type': 'custom',
              'id': custom['id'],
              'name': custom['name'],
              'price': custom['amount'].toString()
            },
          );
        }
      }
    }
  }

  // void _onItemSelect(bool? selected, Map<String, dynamic> item) {
  //   setState(() {
  //     if (selected!) {
  //       selectedItems!.add(item);
  //     } else {
  //       selectedItems!.removeWhere(
  //           (Map<String, dynamic> element) => element['id'] == item['id']);
  //     }
  //   });
  // }

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

  @override
  Widget build(BuildContext context) {
    // int selectedOption = 0;
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.order != null ? 'Update Order' : 'Create New Order',
          style: const TextStyle(
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
                        // CustomDropdownWidget(
                        //   caption: 'Client\'s Name',
                        //   items: const <String>['clients', 'clients'],
                        //   iconName: 'assets/svgs/dropdown.svg',
                        //   initialValue: selectedClient,
                        //   onChanged: (String? value) {
                        //     setState(() {
                        //       selectedClient = value!;
                        //     });
                        //   },
                        // ),
                        GestureDetector(
                          onTap: () {
                            _showClientSheet(context);
                          },
                          child: CustomTextWidget(
                            padding: 15,
                            textpadding: 15,
                            caption: 'Client\'s Name',

                            // items: clientsName,
                            iconName: 'assets/svgs/dropdown.svg',
                            text: selectedClient,
                            // initialValue: selectedClient,
                            // onChanged: (String? value) {
                            //   setState(() {
                            //     selectedClient = value!;
                            //     _onClientSelect(value);
                            //   });
                            // },
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (selectedItems!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Selected Orders',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ...selectedItems!.asMap().entries.map(
                                      (MapEntry<int, Map<String, dynamic>>
                                          entry) {
                                    final int index = entry.key;
                                    final Map<String, dynamic> task =
                                        entry.value;
                                    return Taskitem(
                                      isOrder: true,
                                      taskname: task['name'],
                                      taskexpense:
                                          '${shopController.shop!.currency} ${task['price']}',
                                      imageurl: task['images'],
                                      deleteOnTap: () {
                                        setState(() {
                                          selectedItems!.removeAt(index);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        if (selectedItems!.isNotEmpty)
                          const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () {
                            if (!canAdd) {
                              showSnackbar(
                                message: 'Already Added Custom Order!',
                                error: true,
                              );
                              return;
                            }
                            _showOrderSheet(context);
                          },
                          child: const CustomTextWidget(
                            padding: 15,
                            textpadding: 15,
                            text: '',

                            // items: clientsName,
                            iconName: 'assets/svgs/dropdown.svg',
                            caption: 'Select Order',

                            // initialValue: selectedClient,
                            // onChanged: (String? value) {
                            //   setState(() {
                            //     selectedClient = value!;
                            //     _onClientSelect(value);
                            //   });
                            // },
                          ),
                        ),

                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Order Channel',
                          items: const <String>['Online', 'In-Person'],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: selectedOrderChannel,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOrderChannel = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != selectedOrderDate) {
                              setState(() {
                                selectedOrderDate =
                                    picked.toString().split(' ')[0];
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CustomTextWidget(
                              caption: 'Order Date',
                              iconName: 'assets/svgs/calendar.svg',
                              text: selectedOrderDate,
                              textpadding: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownWidget(
                          caption: 'Payment Method',
                          items: paymentMethod,
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
                          caption: 'Delivery Method',
                          items: const <String>['Online', 'In-Person'],
                          iconName: 'assets/svgs/dropdown.svg',
                          initialValue: initialDeliveryMethod,
                          onChanged: (String? value) {
                            setState(() {
                              if (value != 'Online') {
                                selectedDeliveryMethod = 'online';
                              } else {
                                selectedDeliveryMethod = 'in_person';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomEditText(
                          caption: 'Notes',
                          hintText: 'Add order notes here',
                          controller: notesController,
                          maxLength: 300,
                        ),
                        const SizedBox(height: 15),
                        InvoiceOptionsWidget(
                          onOptionSelected: (int selectedOption) {
                            // print('Selected option: $selectedOption');
                          },
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
                      loading: isSubmit,
                      text: widget.order != null ? 'Update' : 'Create',
                      onPressed: _submitOrder,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void _selectOrderDate(BuildContext context) async {}
}
