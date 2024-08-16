import 'package:business_bosses_v2/bbpro/common/widgets/customcard.dart';
import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/multipleedit.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:get/get.dart';

class Addclient extends StatefulWidget {
  const Addclient({super.key});

  @override
  State<Addclient> createState() => _AddclientState();
}

class _AddclientState extends State<Addclient> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ClientsController clientsController = Get.put(ClientsController());
  final ClientType _selectedType = ClientType.online;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add Client',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    CustomCard(
                      buttonvisible: true,
                      caption: 'Client Information',
                      subText: 'Add a photo for your client',
                      buttonText: 'Choose Photo',
                      onPressed: () {},
                      imagePath: 'assets/images/shopplaceholder.png',
                      iconpath: 'assets/svgs/uploadicon.svg',
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Client\'s Name',
                      hintText: 'Enter name here',
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    MultipleEditTextWidget(
                      caption: 'Client\'s Email',
                      hintText: 'example@business.com',
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    MultipleEditTextWidget(
                      caption: 'Client\'s Phone number',
                      hintText: '+234 000 000 000',
                      controller: phoneController,
                    ),
                    const SizedBox(height: 15),
                    CustomDropdownWidget(
                      caption: 'Client Type',
                      items: ClientType.values
                          .map((ClientType type) => type.displayTitle)
                          .toList(),
                      iconName: 'assets/svgs/dropdown.svg',
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
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
                text: 'Save',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle the save action
                    final Map<String, dynamic> data = <String, dynamic>{
                      'userId': profileController
                          .myProfile.uid, // Fetch the user ID if applicable
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'type': _selectedType.displayTitle,
                      'createdAt': DateTime.now().toString(),
                      'image': <String>[], // Handle images if necessary
                    };

                    final bool response =
                        await clientsController.addClient(data);

                    if (response) {
                      Get.back();
                      showSnackbar(message: 'Client Added Successfully!');
                    } else {
                      showSnackbar(
                        message: 'Error Adding Client!',
                        error: true,
                      );
                    }

                    // Call your API or service to save the client information
                    // Example: ApiService.post(path: 'clients', body: client.toMap());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
