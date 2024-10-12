import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ClientWidget extends StatefulWidget {
  final Client client;
  final Color bgcolor;
  final bool? isExpanded;

  const ClientWidget({
    required this.client,
    required this.bgcolor,
    super.key,
    this.isExpanded,
  });

  @override
  State<ClientWidget> createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  @override
  Widget build(BuildContext context) {
    final ClientsController clientsController = Get.find();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: widget.bgcolor.withAlpha(50), // Border color
            width: 0.5, // Border width
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: widget.bgcolor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/client.svg',
                          height: 10,
                          color: textColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.client.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          ' - ${widget.client.type.displayTitle}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ]),
                ),
                OptionsButton(
                  onEdit: () {
                    Get.to(() => Addclient(
                          client: widget.client,
                        ));
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          'Delete Client',
                          style: bodyText1,
                        ),
                        content: const Text(
                            'Are you sure you want to delete this client?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final bool delete = await clientsController
                                  .deleteClient(widget.client.id);
                              if (delete) {
                                showSnackbar(
                                    message: 'Client deleted successfully!');
                              } else {
                                showSnackbar(
                                    message: 'Error deleting client!',
                                    error: true);
                              }
                              setState(() {});
                              Get.back();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(0),
                  borderColor: Colors.white,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Email: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.client.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Phone: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.client.phone,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // if (isExpanded != false)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //       GestureDetector(
            //         onTap: () {
            //           showDialog(
            //             context: context,
            //             builder: (BuildContext context) => const ProjectPopUp(),
            //           );
            //         },
            //         child: CircleAvatar(
            //           backgroundColor: probackgroundColor,
            //           radius: 15,
            //           child: SvgPicture.asset(
            //             'assets/svgs/expandform.svg',
            //             color: proprimaryColor,
            //           ),
            //         ),
            //       )
            //     ],
            //   )
          ],
        ),
      ),
    );
  }
}
