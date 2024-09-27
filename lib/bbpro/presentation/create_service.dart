import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/multipleedit.dart';
import 'package:business_bosses_v2/bbpro/widgets/switchwidget.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CreateServiceListing extends StatefulWidget {
  final Service? service;
  const CreateServiceListing({super.key, this.service});

  @override
  // ignore: library_private_types_in_public_api
  _CreateServiceListingState createState() => _CreateServiceListingState();
}

class _CreateServiceListingState extends State<CreateServiceListing>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ShopController shopController = Get.put(ShopController());
  final ProfileController profileController = Get.find();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = <File>[];
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  bool isSubmitted = false;
  bool _isSwitched = false;

  // Form fields
  String? category;
  String? location;
  List<String>? images = <String>[];
  String? paymentMethod;
  String? deliveryMethod;
  String? deliveryTime;
  DateTime? availableTime;
  String? serviceType;

  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<DateTime> _selectedDates = <DateTime>[];
  bool _isAlwaysAvailable = false;
  final List<bool> _selectedWeekdays = List<bool>.filled(7, false);
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _startTimeSelected = false;
  bool _endTimeSelected = false;
  List<String> paymentMethods = <String>[];

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
      _serviceNameController.text = widget.service!.name;
      _priceController.text = widget.service!.price.toString();
      _discountController.text = widget.service!.discount.toString();
      _descriptionController.text = widget.service!.description;
      category = widget.service!.category;
      location = widget.service!.location;
      deliveryMethod = widget.service!.deliveryMethod;
      deliveryTime = widget.service!.deliveryTime;
      availableTime = widget.service!.availableTime;
      serviceType = widget.service!.serviceType;
      paymentMethod = widget.service!.paymentMethod;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.service != null ? 'Edit Service' : 'Create Service Listing',
          style: const TextStyle(
            color: proprimaryColor,
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
              caption: 'Service Name',
              hintText: 'Enter service name here',
              controller: _serviceNameController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a service name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: <Widget>[
                Expanded(
                  child: CustomEditText(
                    caption: 'Price',
                    hintText: 'Enter price in USD',
                    controller: _priceController,
                    inputType: TextInputType.number,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CustomEditText(
                      padding: 0,
                      caption: 'Discount',
                      hintText: 'Enter discount',
                      controller: _discountController,
                      inputType: TextInputType.number,
                      validator: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomEditText(
              caption: 'Describe your Service',
              hintText: 'Add service description here',
              controller: _descriptionController,
              maxLength: 300,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomDropdownWidget(
              initialValue: category,
              caption: 'Select Category',
              hintText: 'Choose a category',
              items: const <String>[
                'Design Services',
                'Consulting',
                'Technical Support'
              ],
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  category = newValue;
                });
              },
            ),

            // Select Category Dropdown
            // DropdownButtonFormField<String>(
            //   decoration: const InputDecoration(
            //     labelText: 'Select Category',
            //     border: OutlineInputBorder(),
            //   ),
            //   value: category,
            //   items: <String>[
            //     'Design Services',
            //     'Consulting',
            //     'Technical Support'
            //   ].map((String category) {
            //     return DropdownMenuItem<String>(
            //       value: category,
            //       child: Text(category),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       category = newValue;
            //     });
            //   },
            // ),
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
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                initialSelection: location,
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
                      text: location ?? 'Select Location',
                    ),
                  );
                },
                onChanged: (CountryCode? code) {
                  setState(() {
                    location = code?.name;
                  });
                },
                useSafeArea: false,
              ),
            ),
            const SizedBox(height: 16),

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
                        Text('Add Attachment'),
                        Icon(Icons.image),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_selectedImages.isNotEmpty)
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
                  itemCount: _selectedImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      _selectedImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

            // Delivery Method Dropdown
            CustomDropdownWidget(
              initialValue: deliveryMethod,
              caption: 'Delivery Method',
              hintText: 'Choose a delivery method',
              items: const <String>['Online', 'In-Person'],
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  deliveryMethod = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            availabilityWidget(),

            // Delivery Time Field
            // TextFormField(
            //   decoration: const InputDecoration(
            //     labelText: 'Delivery Time',
            //     hintText: 'e.g., 3-5 business days',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (String value) {
            //     setState(() {
            //       deliveryTime = value;
            //     });
            //   },
            // ),
            const SizedBox(height: 16),

            // Available Time Field
            // TextFormField(
            //   readOnly: true,
            //   decoration: InputDecoration(
            //     labelText: 'Available Time',
            //     hintText: _formatDate(availableTime),
            //     border: const OutlineInputBorder(),
            //   ),
            //   onTap: () => _selectDate(context),
            // ),
            // const SizedBox(height: 16),

            // Payment Method Dropdown

            CustomDropdownWidget(
              caption: 'Payment Method',
              hintText: 'Choose a payment method',
              items: paymentMethods,
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  paymentMethod = newValue;
                });
              },
            ),

            const SizedBox(height: 16),

            // Service Type Field
            CustomDropdownWidget(
              caption: 'Service Type',
              hintText: 'Choose a service type',
              items: const <String>[
                '1:1 (Individual)',
                '1 to Many',
              ],
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  serviceType = newValue;
                });
              },
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: MultipleEditTextWidget(
                  caption: 'Add Additional Packages to this service',
                  hintText: 'Package Name',
                  controller: _serviceNameController),
            ),
            const SizedBox(height: 16),
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
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Submit Button
            ProCustomButton(
              loading: isSubmitted,
              text: widget.service != null ? 'Save Changes' : 'Create Service',
              onPressed: _submitForm,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Select date';
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: availableTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != availableTime) {
      setState(() {
        availableTime = picked;
      });
    }
  }

  void _submitForm() async {
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
    }

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        isSubmitted = true;
      });
      for (File image in _selectedImages) {
        dynamic response = await ApiService.uploadFile(image);
        if (response['success']) {
          setState(() {
            images!.add(response['fileUrl']);
          });
        }
      }
      // Create a map to hold form data
      final Map<String, dynamic> serviceData = <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'shopId': shopController.shop?.id,
        'name': _serviceNameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'discount': _discountController.text,
        'category': category,
        'location': location,
        'images': images,
        'paymentMethod': paymentMethod,
        'deliveryMethod': deliveryMethod,
        'deliveryTime': deliveryTime,
        'availableTime': availableTime?.toIso8601String(),
        'serviceType': serviceType,
        'itemType': 'service',
        'isActive': true
      };

      // For demonstration, print the map
      // You can now send this data to your API or database
      // Example:
      await shopController.addService(serviceData).then((bool response) {
        if (response) {
          // Handle success
          showSnackbar(message: 'Service Added Succesfully!');
          Navigator.pop(context);
        } else {
          // Handle error
          showSnackbar(message: 'Error Adding Service!', error: true);
        }
      }).catchError((dynamic error) {
        Get.snackbar('Error', 'An unexpected error occurred');
      });
      setState(() {
        isSubmitted = false;
      });
      // Clear the form or navigate to another screen if needed
    }
  }

  Widget availabilityWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(radius)),
        padding: const EdgeInsets.all(15),
        height: 600, // Increased height to accommodate time selection
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Available Days'),
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
                      if (_isAlwaysAvailable) {
                        _selectedWeekdays.fillRange(0, 7, true);
                      } else {
                        _selectedWeekdays.fillRange(0, 7, false);
                      }
                      _updateSelectedDates();
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
                              ? proprimaryColor
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
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: proprimaryColor,
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
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(7, (int index) {
                return ChoiceChip(
                  label: Text(_getWeekdayName(index)),
                  selected: _selectedWeekdays[index],
                  selectedColor: proprimaryColor,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedWeekdays[index] = selected;
                      _updateSelectedDates();
                    });
                  },
                );
              }),
            ),
            Expanded(
              child: _isAlwaysAvailable
                  ? const Center(child: Text('Always Available'))
                  : SfCalendar(
                      selectionDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      todayHighlightColor: proprimaryColor,
                      view: CalendarView.month,
                      initialDisplayDate: DateTime.now(),
                      monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator,
                      ),
                      dataSource: _getCalendarDataSource(),
                      onTap: null,
                    ),
            ),
            const SizedBox(height: 20),
            const Text('Available Time for selected days'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () => _selectTime(context, true),
                  child: Text(
                    'Start Time: ${_startTime.format(context)}',
                    style: TextStyle(
                      color: _startTimeSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectTime(context, false),
                  child: Text(
                    'End Time: ${_endTime.format(context)}',
                    style: TextStyle(
                      color: _endTimeSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int index) {
    List<String> weekdays = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    return weekdays[index];
  }

  void _updateSelectedDates() {
    _selectedDates.clear();
    if (!_isAlwaysAvailable) {
      DateTime now = DateTime.now();
      for (int i = 0; i < 365; i++) {
        DateTime date = now.add(Duration(days: i));
        if (_selectedWeekdays[date.weekday - 1]) {
          _selectedDates.add(date);
        }
      }
    }
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

  // void _handleCalendarTap(CalendarTapDetails details) {
  //   if (!_isAlwaysAvailable &&
  //       details.targetElement == CalendarElement.calendarCell) {
  //     setState(() {
  //       DateTime selectedDate = DateTime(
  //           details.date!.year, details.date!.month, details.date!.day);
  //       if (_selectedDates.contains(selectedDate)) {
  //         _selectedDates.remove(selectedDate);
  //       } else {
  //         _selectedDates.add(selectedDate);
  //       }
  //     });
  //   }
  // }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
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
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
