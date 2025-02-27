import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/boost_items.dart';
import 'package:business_bosses_v2/bbpro/widgets/add_package_bottomsheet.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/switchwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskitem.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/features/posts/widgets/image_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:get/get.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CreateServiceListing extends StatefulWidget {
  final bool? isMarketplace;
  final Service? service;
  const CreateServiceListing({super.key, this.service, this.isMarketplace});

  @override
  // ignore: library_private_types_in_public_api
  _CreateServiceListingState createState() => _CreateServiceListingState();
}

class _CreateServiceListingState extends State<CreateServiceListing>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ShopController shopController =
      Get.put(ShopController(), permanent: true);
  final ProfileController profileController = Get.find();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = <File>[];
  List<Map<String, dynamic>> packages = <Map<String, dynamic>>[];
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController packageNameController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController addressorlinkController = TextEditingController();
  final TextEditingController groupmembersController = TextEditingController();

  bool isSubmitted = false;
  bool _isSwitched = true;
  bool isExpanded = false;

  // Form fields
  String? category;
  String location = '';
  List<String> images = <String>[];
  List<String>? updateImages = <String>[];
  String? paymentMethod;
  String? deliveryMethod;
  String? selectedServiceDuration;
  DateTime availableTime = DateTime.now();
  String? serviceType;
  Map<String, dynamic>? availability;

  late AnimationController _animationController;
  late Animation<double> _animation;
  List<DateTime> _selectedDates = <DateTime>[];
  bool _isAlwaysAvailable = false;
  final List<bool> _selectedWeekdays = List<bool>.filled(7, false);
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _startTimeSelected = false;
  bool _endTimeSelected = false;
  List<String> paymentMethods = <String>[];
  List<String> selectedSubmitWeekdays = <String>[];
  List<String> weekdays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  String frequency = 'No (One-time Service)';
  DateTime? _startDate;
  DateTime? _endDate;
  String deliveryTime = 'false';
  int? duration;
  bool? customduration = false;
  String? servicePeriod = 'minute(s)';
  String? servicePeriodnumber;
  String? calendarType = 'Single day';
  bool? isAppointment = false;
  final bool _shouldPromote = true;
  final List<String> categories = <String>[
    'Agriculture, Food & Beverage',
    'Books & Education',
    'Construction & Real Estate',
    'Fashion & Beauty',
    'Finance & Legal',
    'Healthcare & Wellness',
    'Home, Gardens & Outdoors',
    'Jewellery & Timepieces',
    'Media & Entertainment',
    'Security, Safety & Equipment',
    'Technology, Games & Electronic',
    'Vehicle & Transportation'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    for (dynamic payments in shopController.shop!.payments) {
      paymentMethods.add(payments['paymentMethod']);
    }
    if (widget.service != null) {
      isAppointment = widget.service!.isAppointment;
      duration = widget.service!.serviceDuration;
      frequency = widget.service!.repeat!;
      _isAlwaysAvailable =
          widget.service!.deliveryTime == 'true' ? true : false;
      deliveryTime = widget.service!.deliveryTime.toString();
      groupmembersController.text = widget.service!.participants.toString();
      _serviceNameController.text = widget.service!.name;
      _priceController.text = widget.service!.price.toString();
      _discountController.text = widget.service!.discount.toString();
      _descriptionController.text = widget.service!.description;
      category = widget.service!.category;
      location = widget.service!.location;
      images = widget.service!.images!;
      updateImages = widget.service!.images;
      deliveryMethod = widget.service!.deliveryMethod;
      availableTime = widget.service!.availableTime != null
          ? widget.service!.availableTime!
          : DateTime.now();
      serviceType = widget.service!.serviceType;
      paymentMethod = widget.service!.paymentMethod;
      notesController.text = widget.service!.notes ?? '';
      addressorlinkController.text = widget.service!.url ?? '';
      _selectedDates = (widget.service!.selectedDates)
          .map((dynamic date) => DateTime.parse(date.toString()))
          .toList();

      packages = List<Map<String, dynamic>>.from(widget.service!.packages);
      availability = widget.service!.availability;
      _startDate = widget.service!.availability == null ||
              widget.service!.availability!['startDate'] == null
          ? null
          : DateTime.parse(widget.service!.availability!['startDate']);
      _endDate = widget.service!.availability == null ||
              widget.service!.availability!['endDate'] == null
          ? null
          : DateTime.parse(widget.service!.availability!['endDate']);
      _startTime = TimeOfDay(
          hour: widget.service!.availability == null
              ? 0
              : int.parse(
                  widget.service!.availability!['startTime'].substring(0, 2)),
          minute: widget.service!.availability == null
              ? 0
              : int.parse(
                  widget.service!.availability!['startTime'].substring(3, 5)));
      _endTime = TimeOfDay(
          hour: widget.service!.availability == null
              ? 0
              : int.parse(widget.service!.availability!['endTime']
                  .substring(0, 2)), // Extract hour
          minute: widget.service!.availability == null
              ? 0
              : int.parse(widget.service!.availability!['endTime']
                  .substring(3, 5))); // Extract minute

      selectedSubmitWeekdays =
          List<String>.from(availability?['dayOfWeek'] ?? <String>[]);
      for (int i = 0; i < weekdays.length; i++) {
        if (selectedSubmitWeekdays.contains(weekdays[i])) {
          _selectedWeekdays[i] = true;
        }
      }

      // _updateSelectedDates();
      _startTimeSelected = true;
      _endTimeSelected = true;
    }
    currencyController.text = shopController.shop?.location != null
        ? '${currencyValues[shopController.shop!.location.toString()]}'
        : 'USD';
    setState(() {});
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) {
      showSnackbar(message: 'Maximum of 5 images allowed', error: true);
      return;
    }
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images
            .map((XFile image) => File(image.path))
            .take(5 - _selectedImages.length)); // Limit to 5 images
        if (_selectedImages.length > 5) {
          _selectedImages.removeRange(5, _selectedImages.length);
        }
      });
    }
  }

  void _showAddPackageSheet(BuildContext context) {
    packageNameController.clear();
    expenseController.clear();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddPackageBottomSheet(
          currencyController: currencyController,
          packageNameController: packageNameController,
          expenseController: expenseController,
          onPressed: () {
            final Map<String, dynamic> package = <String, dynamic>{
              'name': packageNameController.text.trim(),
              'price': expenseController.text.trim(),
            };

            setState(() {
              packages.add(package);
            });

            Get.back();
          },
        );
      },
    );
  }

  _editPackageSheet(BuildContext context, int index) {
    Map<String, dynamic> packageToEdit = packages[index];

    packageNameController.text = packageToEdit['name'];
    expenseController.text = packageToEdit['price'];

    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddPackageBottomSheet(
          currencyController: currencyController,
          packageNameController: packageNameController,
          expenseController: expenseController,
          onPressed: () {
            final Map<String, dynamic> updatedPackage = <String, dynamic>{
              'name': packageNameController.text.trim(),
              'price': expenseController.text.trim(),
            };

            // Update the task in the list
            setState(() {
              packages[index] = updatedPackage;
            });

            Get.back();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.service != null ? 'Edit Service' : 'Create Service Listing',
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 16),

            CustomEditText(
              caption: 'Service Name *',
              hintText: 'Enter service name here',
              maxLength: 30,
              controller: _serviceNameController,
            ),
            const SizedBox(height: 16),

            Row(
              children: <Widget>[
                Expanded(
                  child: CustomEditText(
                    maxLength: 15,
                    iscurrencyfield: true,
                    currencycontroller: currencyController,
                    caption: 'Price *',
                    hintText: 'Enter price',
                    controller: _priceController,
                    inputType: TextInputType.number,
                  ),
                ),
                Expanded(
                  child: CustomEditText(
                    isps: true,
                    maxLength: 15,
                    caption: 'Discount(%)',
                    hintText: 'Enter discount',
                    controller: _discountController,
                    inputType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomEditText(
              caption: 'Describe your Service *',
              hintText: 'Add service description here',
              controller: _descriptionController,
              maxLength: 300,
            ),
            const SizedBox(height: 16),
            CustomDropdownWidget(
              initialValue: category,
              caption: 'Select Category *',
              hintText: 'Choose a category',
              items: categories,
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  category = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Location Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: CountryListPick(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'Select Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ),
                initialSelection:
                    location.isEmpty ? shopController.shop?.location : location,
                pickerBuilder:
                    (BuildContext context, CountryCode? countryCode) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radiusValue),
                    ),
                    child: CustomTextWidget(
                      caption: 'Location',
                      iconName: 'assets/svgs/nexticon.svg',
                      text: location.isEmpty
                          ? shopController.shop!.location
                          : location,
                    ),
                  );
                },
                onChanged: (CountryCode? code) {
                  setState(() {
                    location = code!.name!;
                    currencyController.text =
                        '${currencyValues[code.name.toString()]}';
                  });
                },
                useSafeArea: false,
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SwitchWidget(
                value: isAppointment!,
                onChanged: (bool value) {
                  setState(() {
                    isAppointment = value;
                  });
                },
                caption: 'Is this an Appointment Service',
                subtext:
                    'If this is an appointment service, you must choose a duration, select a date and time for bookings.',
                activeColor: primaryColorLT,
                inactiveColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomDropdownWidget(
                padding: 0,
                caption: isAppointment == false
                    ? 'Duration (Optional)'
                    : 'Duration *',
                hintText: 'Choose duration for your service',
                items: const <String>[
                  '5 mins',
                  '10 mins',
                  '15 mins',
                  '20 mins',
                  '30 mins',
                  '45 mins',
                  '60 mins (1 hour)',
                  'Custom'
                ],
                iconName: 'assets/svgs/dropdown.svg',
                initialValue: duration.toString(),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue == 'Custom') {
                      customduration = true;
                    } else {
                      customduration = false;
                      final RegExp regex = RegExp(r'\d+');
                      final Match? match = regex.firstMatch(newValue!);
                      if (match != null) {
                        duration = int.tryParse(match.group(0) ?? '') ?? 0;
                      }
                    }
                  });
                },
                secondarysection: customduration == true
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(fontSize: 13),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Number of $servicePeriod',
                                filled: false,
                                fillColor: Colors.grey.shade100,
                                counterText: '',
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  servicePeriodnumber = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    radiusValue,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              value: 'minute(s)',
                              padding: EdgeInsets.zero,
                              onChanged: (String? newValue) {
                                setState(() {
                                  servicePeriod = newValue;
                                });
                              },
                              icon: SvgPicture.asset(
                                'assets/svgs/dropdown.svg',
                                color: widget.isMarketplace != null
                                    ? primaryColorLT
                                    : proprimaryColor,
                              ),
                              items: const <String>[
                                'minute(s)',
                                'hour(s)',
                                'day(s)',
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          )
                        ],
                      )
                    : null,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            // Add Attachment (Image Picker)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: _pickImage,
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
                        Text('Add Attachment',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        Icon(Icons.image),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _selectedImages.length + updateImages!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < _selectedImages.length) {
                    return ImageItem(
                      file: _selectedImages[index],
                      onRemove: () {
                        setState(() {
                          _selectedImages.removeAt(index);
                        });
                      },
                      imageUrl: null,
                    );
                  } else {
                    final int updateIndex = index - _selectedImages.length;
                    return ImageItem(
                      file: null,
                      onRemove: () {
                        setState(() {
                          updateImages!.removeAt(updateIndex);
                        });
                      },
                      imageUrl: updateImages![updateIndex],
                    );
                  }
                },
              ),
            ),

            // Delivery Method Dropdown
            ExpansionTile(
              initiallyExpanded: true,
              trailing: isExpanded
                  ? SvgPicture.asset(
                      'assets/svgs/dropdownexpansionup.svg',
                    )
                  : SvgPicture.asset(
                      'assets/svgs/dropdownexpansion.svg',
                    ),
              title: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Additional Information',
                        style: TextStyle(color: textColor)),
                    TextSpan(
                        text: ' (Optional)',
                        style: TextStyle(color: hintColor)),
                  ],
                ),
              ),
              children: <Widget>[
                CustomDropdownWidget(
                  initialValue: deliveryMethod,
                  caption: 'Delivery Method',
                  hintText: 'Choose a delivery method',
                  items: const <String>['None', 'Online', 'In-Person'],
                  iconName: 'assets/svgs/dropdown.svg',
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue == 'None') {
                        deliveryMethod = null;
                        return;
                      }
                      deliveryMethod = newValue;
                      addressorlinkController.clear();
                    });
                  },
                  secondarysection: deliveryMethod != null
                      ? TextFormField(
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: deliveryMethod == 'Online'
                                ? 'Enter link here'
                                : 'Enter address here',
                            filled: false,
                            fillColor: Colors.grey.shade100,
                            counterText: null,
                          ),
                          controller: addressorlinkController,
                        )
                      : null,
                ),

                const SizedBox(height: 16),

                CustomDropdownWidget(
                  caption: 'Repeat',
                  hintText: 'Offer this service once or regularly?',
                  items: const <String>[
                    'Yes (Regular Service)',
                    'No (One-time Service)',
                  ],
                  iconName: 'assets/svgs/dropdown.svg',
                  initialValue: frequency,
                  onChanged: (String? newValue) {
                    setState(() {
                      frequency = newValue!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                if (isAppointment != false)
                  availabilityWidget(
                      isRecurring:
                          frequency == 'Yes (Regular Service)' ? true : false),
                // const SizedBox(height: 16),

                // CustomDropdownWidget(
                //   caption: 'Payment Method',
                //   hintText: 'Choose a payment method',
                //   items: paymentMethods,
                //   initialValue: paymentMethod,
                //   iconName: 'assets/svgs/dropdown.svg',
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       paymentMethod = newValue;
                //     });
                //   },
                // ),

                if (isAppointment != false) const SizedBox(height: 16),

                // Service Type Field
                CustomDropdownWidget(
                  caption: 'Service Type',
                  hintText: 'Choose a service type',
                  items: const <String>[
                    '1:1 (Individual)',
                    'Group Session or Event',
                  ],
                  initialValue: serviceType,
                  iconName: 'assets/svgs/dropdown.svg',
                  onChanged: (String? newValue) {
                    setState(() {
                      serviceType = newValue;
                    });
                  },
                ),
                if (serviceType == 'Group Session or Event')
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomEditText(
                      caption: 'Maximum Participants',
                      hintText: 'Enter the maximum number of participants',
                      controller:
                          groupmembersController, // You might want a different controller here
                      inputType: TextInputType.number,
                      validator: (String? value) {
                        if (serviceType == 'Group Session or Event' &&
                            (value == null || value.isEmpty)) {
                          return 'Please enter the maximum number of participants';
                        }
                        if (serviceType == 'Group Session or Event' &&
                            (int.tryParse(value!) == null)) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),

                if (packages.isNotEmpty) const SizedBox(height: 16),
                if (packages.isNotEmpty)
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
                            'Additional Packages',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ...packages
                              .asMap()
                              .entries
                              .map((MapEntry<int, Map<String, dynamic>> entry) {
                            final int index = entry.key;
                            final Map<String, dynamic> task = entry.value;
                            return Taskitem(
                              isPackage: true,
                              taskname: task['name'],
                              taskexpense: shopController.shop!.currency +
                                  task['price'].toString(),
                              editOnTap: () {
                                _editPackageSheet(context, index);
                              },
                              deleteOnTap: () {
                                setState(() {
                                  packages.removeAt(index);
                                });
                              },
                            );
                          }).toList(),
                          const SizedBox(height: 10),
                          if (packages.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ProIconButton(
                                  backgroundColor: Colors.white,
                                  textColor: widget.isMarketplace != null
                                      ? primaryColorLT
                                      : proprimaryColor,
                                  text:
                                      'Add Additional Packages to this service',
                                  onPressed: () {
                                    _showAddPackageSheet(context);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: widget.isMarketplace != null
                                        ? primaryColorLT
                                        : proprimaryColor,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (packages.isEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ProIconButton(
                        backgroundColor: Colors.white,
                        textColor: widget.isMarketplace != null
                            ? primaryColorLT
                            : proprimaryColor,
                        text: 'Add Additional Packages to this service',
                        onPressed: () {
                          _showAddPackageSheet(context);
                        },
                        icon: Icon(
                          Icons.add,
                          size: 20,
                          color: widget.isMarketplace != null
                              ? primaryColorLT
                              : proprimaryColor,
                        ),
                      ),
                    ],
                  ),
                if (packages.isEmpty) const SizedBox(height: 16),
                CustomEditText(
                  caption: 'Message or Question',
                  hintText:
                      'Enter message or question you want your clients to answer',
                  controller: notesController,
                  maxLength: 300,
                ),
                const SizedBox(height: 16),
              ],
            ),

            const SizedBox(height: 16),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: SwitchWidget(
            //     value: _shouldPromote,
            //     onChanged: (bool value) {
            //       setState(() {
            //         _shouldPromote = value;
            //       });
            //     },
            //     icon: 'assets/svgs/rocketblack.svg',
            //     caption: 'Boost this listing',
            //     subtext: 'Reach a wider audience and get more views',
            //     activeColor: primaryColorLT,
            //     inactiveColor: Colors.grey,
            //   ),
            // ),
            // const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SwitchWidget(
                value: _isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
                caption: 'Status',
                subtext:
                    'If status is active, this product will show in your shop',
                activeColor: primaryColorLT,
                inactiveColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Submit Button
            ProCustomButton(
              color: primaryColorLT,
              loading: isSubmitted,
              text: widget.service != null ? 'Save Changes' : 'Create Service',
              onPressed: _submitForm,
            ),

            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                  top: 20,
                  bottom: 50,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text:
                                'By clicking on Create Service, you confirm that you will abide by the ',
                            style: TextStyle(fontSize: 12, color: subtextColor),
                          ),
                          TextSpan(
                            text: 'Biz-Center Guidelines',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColorLT,
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      sellingGuide(context),
                                );
                              },
                          ),
                          const TextSpan(
                            text:
                                ', and declare that the listing does not include any Prohibited Items',
                            style: TextStyle(fontSize: 12, color: subtextColor),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    duration ??= 2000000;

    if (_serviceNameController.text.isEmpty) {
      showSnackbar(
        message: 'Service Name is Mandatory!',
        error: true,
      );
      return;
    } else if (_priceController.text.isEmpty) {
      showSnackbar(
        message: 'Price is Mandatory!',
        error: true,
      );
      return;
    } else if (_descriptionController.text.isEmpty) {
      showSnackbar(
        message: 'Description is Mandatory!',
        error: true,
      );
      return;
    } else if (category == null) {
      showSnackbar(
        message: 'Select a category',
        error: true,
      );
      return;
    } else if (isAppointment == true && duration == 200000) {
      showSnackbar(
        message: 'Duration is Mandatory!',
        error: true,
      );
      return;
    }

    if (servicePeriodnumber != null && servicePeriod != null) {
      int number = int.parse(servicePeriodnumber!);
      switch (servicePeriod) {
        case 'minute(s)':
          duration = number;
          break;
        case 'hour(s)':
          duration = number * 60;
          break;
        case 'day(s)':
          duration = number * 60 * 24;
          break;
      }
    }

    _startTime ??= const TimeOfDay(hour: 9, minute: 0);
    _endTime ??= const TimeOfDay(hour: 17, minute: 0);
    // _startDate ??= DateTime.now();
    // _endDate ??= DateTime.now();
    if (!(_endTime!.hour > _startTime!.hour ||
        (_endTime?.hour == _startTime?.hour &&
            _endTime!.minute >= _startTime!.minute))) {
      showSnackbar(
        message: 'End Time cannot be before Start Time!',
        error: true,
      );
      return;
    }
    if (_shouldPromote && !_isSwitched) {
      showSnackbar(
          message: 'You cannot boost a non-active service', error: true);
      return;
    }

    _showBoostBottomSheet();
  }

  Widget availabilityWidget({required bool isRecurring}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(radius)),
        padding: EdgeInsets.only(
            left: 15, right: 15, bottom: 15, top: !isRecurring ? 0 : 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Select a Date and Time',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                if (!isRecurring)
                  SizedBox(
                    width: 130,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            radiusValue,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedDates.length > 1
                          ? 'Multiple days'
                          : 'Single day',
                      padding: EdgeInsets.zero,
                      onChanged: (String? newValue) {
                        setState(() {
                          calendarType = newValue!;
                        });
                      },
                      icon: SvgPicture.asset(
                        'assets/svgs/dropdown.svg',
                        color: widget.isMarketplace != null
                            ? primaryColorLT
                            : proprimaryColor,
                      ),
                      items: const <String>[
                        'Single day',
                        'Multiple days',
                      ].map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
              ],
            ),
            if (isRecurring)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('I am always available to offer this service'),
                  GestureDetector(
                    onTap: () {
                      _isAlwaysAvailable
                          ? _animationController.reverse()
                          : _animationController.forward();
                      setState(() {
                        _isAlwaysAvailable = !_isAlwaysAvailable;
                        deliveryTime = _isAlwaysAvailable.toString();
                        if (_isAlwaysAvailable) {
                          _selectedWeekdays.fillRange(0, 7, true);
                          selectedSubmitWeekdays = weekdays;
                        } else {
                          _selectedWeekdays.fillRange(0, 7, false);
                          selectedSubmitWeekdays = <String>[];
                        }
                      });
                    },
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: _isAlwaysAvailable
                                ? widget.isMarketplace != null
                                    ? primaryColorLT
                                    : proprimaryColor
                                : Colors.grey,
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: _isAlwaysAvailable ? 20 : 0,
                                right: _isAlwaysAvailable ? 0 : 20,
                                top: 2,
                                bottom: 2,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: _isAlwaysAvailable
                                        ? Icon(
                                            Icons.check,
                                            size: 12,
                                            color: widget.isMarketplace != null
                                                ? primaryColorLT
                                                : proprimaryColor,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            size: 12,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            if (!_isAlwaysAvailable && isRecurring)
              Wrap(
                  spacing: 8,
                  children: List<Widget>.generate(7, (int index) {
                    return ChoiceChip(
                      label: Text(_getWeekdayName(index)),
                      selected: selectedSubmitWeekdays
                          .contains(_getWeekdayName(index)),
                      selectedColor: proprimaryColor,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selectedSubmitWeekdays
                              .contains(_getWeekdayName(index))) {
                            selectedSubmitWeekdays.remove(_getWeekdayName(
                                index)); // Remove if already selected
                          } else {
                            selectedSubmitWeekdays.add(
                                _getWeekdayName(index)); // Add if not selected
                          }
                          selectedSubmitWeekdays.sort((String a, String b) =>
                              weekdays
                                  .indexOf(a)
                                  .compareTo(weekdays.indexOf(b)));
                        });
                      },
                    );
                  })),
            if (!isRecurring)
              SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: SfCalendar(
                    initialSelectedDate: _selectedDates.isNotEmpty
                        ? _selectedDates[0]
                        : DateTime.now(),
                    selectionDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: proprimaryColor.withOpacity(0.5),
                    ),
                    todayTextStyle: const TextStyle(color: Colors.black),
                    todayHighlightColor: Colors.transparent,
                    view: CalendarView.month,
                    initialDisplayDate: _selectedDates.isNotEmpty
                        ? _selectedDates[0]
                        : DateTime.now(),
                    minDate: DateTime.now(),
                    monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator,
                      showAgenda: false,
                    ),
                    dataSource: _getCalendarDataSource(),
                    onTap: (CalendarTapDetails details) {
                      if (!_isAlwaysAvailable &&
                          details.targetElement ==
                              CalendarElement.calendarCell &&
                          details.date != null) {
                        setState(() {
                          DateTime selectedDate = DateTime(
                            details.date!.year,
                            details.date!.month,
                            details.date!.day,
                          );

                          switch (calendarType) {
                            case 'Single day':
                              // Select only one day
                              _selectedDates.clear();
                              _selectedDates.add(selectedDate);
                              break;

                            case 'Multiple days':
                              // Toggle selection for multiple days
                              if (_selectedDates.contains(selectedDate)) {
                                _selectedDates.remove(selectedDate);
                              } else {
                                _selectedDates.add(selectedDate);
                              }
                              break;

                            default:
                              // Handle unknown calendar type if necessary
                              break;
                          }

                          // Update weekdays accordingly
                          _selectedWeekdays.fillRange(0, 7, false);
                          selectedSubmitWeekdays.clear();
                          for (DateTime date in _selectedDates) {
                            int weekdayIndex = date.weekday - 1;
                            _selectedWeekdays[weekdayIndex] = true;
                            selectedSubmitWeekdays
                                .add(_getWeekdayName(weekdayIndex));
                          }

                          // Update _startDate (e.g., first selected date)
                          _startDate = _selectedDates.isNotEmpty
                              ? _selectedDates[0]
                              : null;
                          _endDate = _selectedDates.isNotEmpty
                              ? _selectedDates[0]
                              : null;
                        });
                      }
                    },
                  )),
            const SizedBox(height: 20),
            Text(!isRecurring
                ? 'Available Time for selected day'
                : 'Available Time for selected days'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () => _selectTime(context, true),
                  child: Text(
                    'Start Time: ${_startTime?.format(context) ?? '9:00 AM'}',
                    style: TextStyle(
                      color: _startTimeSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectTime(context, false),
                  child: Text(
                    'End Time: ${_endTime?.format(context) ?? '5:00 PM'}',
                    style: TextStyle(
                      color: _endTimeSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if (duration != null && _startTime != null && _endTime != null)
              const SizedBox(
                height: 10,
              ),
            if (duration != null && _startTime != null && _endTime != null)
              const Text('Time Slots for your service'),
            Wrap(
              spacing: 8.0, // Horizontal spacing between chips
              children: _generateTimeSlots().map((String slot) {
                return ChoiceChip(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: backgroundColor,
                  label: Text(
                    slot,
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                  selected: false,
                  onSelected: (bool selected) {},
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int index) {
    List<String> weekdayss = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    return weekdayss[index];
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = _selectedDates
        .map((DateTime date) => Appointment(
              startTime: date,
              endTime: date,
              subject: 'Available',
              color: proprimaryColor,
              isAllDay: true,
            ))
        .toList();

    return _AppointmentDataSource(appointments);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? const TimeOfDay(hour: 9, minute: 0)
          : _endTime ?? const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _startTimeSelected = true;
        } else {
          _endTime = picked;
          _endTimeSelected = true;
        }
      });
    }
  }

  List<String> _generateTimeSlots() {
    List<String> slots = <String>[];
    if (duration != null && _startTime != null && _endTime != null) {
      DateTime startDate = _selectedDates.isNotEmpty
          ? _selectedDates[0]
          : DateTime.now(); // Fallback to today if no dates are selected
      DateTime startDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      DateTime endDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      while (startDateTime.isBefore(endDateTime)) {
        DateTime slotEndTime = startDateTime.add(Duration(minutes: duration!));
        if (slotEndTime.isAfter(endDateTime)) {
          slotEndTime =
              endDateTime; // Adjust the last slot to end exactly at endDateTime
        }

        // Format the time in 12-hour format with AM/PM
        String formatTime(DateTime dateTime) {
          String hour = (dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12)
              .toString()
              .padLeft(2, '0');
          String minute = dateTime.minute.toString().padLeft(2, '0');
          String period = dateTime.hour < 12 ? 'AM' : 'PM';
          return '$hour:$minute $period';
        }

        slots.add('${formatTime(startDateTime)} - ${formatTime(slotEndTime)}');
        startDateTime = slotEndTime;
      }
    }
    return slots;
  }

  void _showBoostBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svgs/rocket.svg',
                        color: textColor,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Boost Post',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Reach a wider audience and get more views',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Do you want to boost this post/listing?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            widget.isMarketplace == true
                                ? primaryColorLT
                                : proprimaryColor)),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        setState(() {
                          isSubmitted = true;
                        });
                        // 1. Clear the final images list
                        List<String> finalImages = <String>[];

// 2. Add back any *retained* old images
//    (i.e., those still in updateImages)
                        for (String oldImageUrl in updateImages!) {
                          finalImages.add(oldImageUrl);
                        }

// 3. Upload and add newly selected images
                        for (File image in _selectedImages) {
                          final dynamic response =
                              await ApiService.uploadFile(image);
                          if (response['success']) {
                            finalImages.add(response['fileUrl']);
                          }
                        }
                        // Create a map to hold form data
                        try {
                          // First validate required fields
                          if (_serviceNameController.text.isEmpty ||
                              _priceController.text.isEmpty ||
                              _descriptionController.text.isEmpty) {
                            showSnackbar(
                                message: 'Please fill in all required fields',
                                error: true);
                            return;
                          }

                          final Map<String, dynamic> serviceData =
                              <String, dynamic>{
                            'userId': profileController.myProfile.uid,
                            'shopId': shopController.shop?.id,
                            'name': _serviceNameController.text.trim(),
                            'price': _priceController.text.trim(),
                            'description': _descriptionController.text.trim(),
                            'discount': _discountController.text.isEmpty
                                ? '0'
                                : _discountController.text.trim(),
                            'category': category,
                            'serviceDuration': duration,
                            'isAppointment': isAppointment,
                            'location': location.isEmpty
                                ? shopController.shop!.location
                                : location,
                            'participants': groupmembersController.text,
                            'repeat': frequency,
                            'images': finalImages.isEmpty ? null : finalImages,
                            'paymentMethod': '',
                            'deliveryMethod': deliveryMethod ?? '',
                            'availableTime': availableTime.toIso8601String(),
                            'serviceType': serviceType ?? '1:1',
                            'itemType': 'service',
                            'isActive': _isSwitched,
                            'deliveryTime': _isAlwaysAvailable.toString(),
                            'serviceAvailability': <String, dynamic>{
                              'dayOfWeek': selectedSubmitWeekdays.isEmpty
                                  ? <String>[
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                    ]
                                  : selectedSubmitWeekdays,
                              'startTime':
                                  '${_startTime?.hour.toString().padLeft(2, '0')}:${_startTime?.minute.toString().padLeft(2, '0')}:00',
                              'endTime':
                                  '${_endTime?.hour.toString().padLeft(2, '0')}:${_endTime?.minute.toString().padLeft(2, '0')}:00',
                              'startDate': _startDate?.toIso8601String(),
                              'endDate': _endDate?.toIso8601String(),
                            },
                            'servicePackages': packages,
                            'url': addressorlinkController.text,
                            'notes': notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                            'selectedDates': _selectedDates.isEmpty ||
                                    (_selectedDates.length == 1 &&
                                        _selectedDates.first.toString() == '')
                                ? null
                                : _selectedDates
                                    .map((DateTime date) => date.toString())
                                    .toList(),
                          };

                          // Log the cleaned data

                          if (widget.service == null) {
                            final ServiceAddResult result =
                                await shopController.addService(serviceData);
                            if (result.success) {
                              showSnackbar(
                                  message: 'Service Added Successfully!');

                              Get.off(() => BoostItem(
                                    service: result.service,
                                  ));
                              return;
                            } else {
                              String errorMessage = 'Failed to add service';
                              showSnackbar(message: errorMessage, error: true);
                            }
                          } else {
                            final bool result = await shopController
                                .updateService(widget.service!.id, serviceData);
                            if (result) {
                              showSnackbar(
                                  message: 'Service Updated Successfully!');

                              Get.off(() => BoostItem(
                                    service: widget.service,
                                  ));
                              return;
                            } else {
                              String errorMessage = 'Failed to edit service';
                              showSnackbar(message: errorMessage, error: true);
                            }
                          }
                        } catch (e) {
                          print(e);
                          String errorMessage = 'Failed to add service';
                          showSnackbar(message: errorMessage, error: true);
                        } finally {
                          setState(() {
                            isSubmitted = false;
                          });
                        }
                      }
                    },
                    child: const Text('Yes'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.isMarketplace == true
                          ? primaryColorLT
                          : proprimaryColor,
                      side: BorderSide(
                          color: widget.isMarketplace == true
                              ? primaryColorLT
                              : proprimaryColor,
                          width: 1),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        setState(() {
                          isSubmitted = true;
                        });
                        // 1. Clear the final images list
                        List<String> finalImages = <String>[];

// 2. Add back any *retained* old images
//    (i.e., those still in updateImages)
                        for (String oldImageUrl in updateImages!) {
                          finalImages.add(oldImageUrl);
                        }

// 3. Upload and add newly selected images
                        for (File image in _selectedImages) {
                          final dynamic response =
                              await ApiService.uploadFile(image);
                          if (response['success']) {
                            finalImages.add(response['fileUrl']);
                          }
                        }
                        // Create a map to hold form data
                        try {
                          // First validate required fields
                          if (_serviceNameController.text.isEmpty ||
                              _priceController.text.isEmpty ||
                              _descriptionController.text.isEmpty) {
                            showSnackbar(
                                message: 'Please fill in all required fields',
                                error: true);
                            return;
                          }

                          final Map<String, dynamic> serviceData =
                              <String, dynamic>{
                            'userId': profileController.myProfile.uid,
                            'shopId': shopController.shop?.id,
                            'name': _serviceNameController.text.trim(),
                            'price': _priceController.text.trim(),
                            'description': _descriptionController.text.trim(),
                            'discount': _discountController.text.isEmpty
                                ? '0'
                                : _discountController.text.trim(),
                            'category': category,
                            'serviceDuration': duration,
                            'isAppointment': isAppointment,
                            'location': location.isEmpty
                                ? shopController.shop!.location
                                : location,
                            'participants': groupmembersController.text,
                            'repeat': frequency,
                            'images': finalImages.isEmpty ? null : finalImages,
                            'paymentMethod': '',
                            'deliveryMethod': deliveryMethod ?? '',
                            'availableTime': availableTime.toIso8601String(),
                            'serviceType': serviceType ?? '1:1',
                            'itemType': 'service',
                            'isActive': _isSwitched,
                            'deliveryTime': _isAlwaysAvailable.toString(),
                            'serviceAvailability': <String, dynamic>{
                              'dayOfWeek': selectedSubmitWeekdays.isEmpty
                                  ? <String>[
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                    ]
                                  : selectedSubmitWeekdays,
                              'startTime':
                                  '${_startTime?.hour.toString().padLeft(2, '0')}:${_startTime?.minute.toString().padLeft(2, '0')}:00',
                              'endTime':
                                  '${_endTime?.hour.toString().padLeft(2, '0')}:${_endTime?.minute.toString().padLeft(2, '0')}:00',
                              'startDate': _startDate?.toIso8601String(),
                              'endDate': _endDate?.toIso8601String(),
                            },
                            'servicePackages': packages,
                            'url': addressorlinkController.text,
                            'notes': notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                            'selectedDates': _selectedDates.isEmpty ||
                                    (_selectedDates.length == 1 &&
                                        _selectedDates.first.toString() == '')
                                ? null
                                : _selectedDates
                                    .map((DateTime date) => date.toString())
                                    .toList(),
                          };

                          // Log the cleaned data

                          if (widget.service == null) {
                            final ServiceAddResult result =
                                await shopController.addService(serviceData);
                            if (result.success) {
                              Get.back();
                              showSnackbar(
                                  message: 'Service Added Successfully!');

                              return;
                            } else {
                              String errorMessage = 'Failed to add service';
                              showSnackbar(message: errorMessage, error: true);
                            }
                          } else {
                            final bool result = await shopController
                                .updateService(widget.service!.id, serviceData);
                            if (result) {
                              Get.back();
                              showSnackbar(
                                  message: 'Service Updated Successfully!');

                              return;
                            } else {
                              String errorMessage = 'Failed to edit service';
                              showSnackbar(message: errorMessage, error: true);
                            }
                          }
                        } catch (e) {
                          print(e);
                          String errorMessage = 'Failed to add service';
                          showSnackbar(message: errorMessage, error: true);
                        } finally {
                          setState(() {
                            isSubmitted = false;
                          });
                        }
                      }
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
