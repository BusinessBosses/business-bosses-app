import 'dart:convert';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BuyerRequests extends StatefulWidget {
  const BuyerRequests({super.key});

  @override
  State<BuyerRequests> createState() => _BuyerRequestsState();
}

class _BuyerRequestsState extends State<BuyerRequests> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startPriceController = TextEditingController();
  final TextEditingController _endPriceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();

  final ShopController shopController = Get.find();
  final BuyerRequestController buyerRequestController =
      Get.put(BuyerRequestController());
  final ProfileController profileController = Get.find();

  String country = '';
  String _selectedCategory = '';
  DateTime? _selectedDeadline;
  List<PlatformFile> _attachments = <PlatformFile>[];

  final List<String> _categories = <String>[
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
    'Vehicle & Transportation',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    currencyController.text = 'USD';
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: <String>[
        'pdf',
        'doc',
        'docx',
        'txt',
        'png',
        'jpg',
        'jpeg',
        'gif'
      ],
    );

    if (result != null) {
      setState(() {
        _attachments =
            <PlatformFile>[..._attachments, ...result.files].take(5).toList();
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDeadline ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> body = <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'budget_start': _startPriceController.text,
        'budget_end': _endPriceController.text,
        'deadline': _selectedDeadline?.toIso8601String() ?? '',
        'attachments':
            jsonEncode(_attachments.map((PlatformFile f) => f.name).toList()),
        'location': country.isEmpty ? shopController.shop!.location : country,
      };

      await buyerRequestController.addBuyerRequest(body);

      if (!buyerRequestController.error.value) {
        Get.snackbar(
          'Success',
          'Buyer request posted successfully!',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[900],
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Failed to post buyer request.',
          backgroundColor: Colors.red[50],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSubmitting = buyerRequestController.loading.value;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Create Buyer Request',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 0),
                    CustomEditText(
                      caption: 'Request Title *',
                      maxLength: 30,
                      hintText:
                          'e.g., Need a responsive website for my startup',
                      controller: _titleController,
                      validator: (String? value) =>
                          value == null || value.trim().isEmpty
                              ? 'Title is required'
                              : null,
                    ),

                    CustomEditText(
                      caption: 'Description *',
                      hintText:
                          'Describe your requirements in detail. Include specific deliverables, quality expectations, and any important constraints...',
                      controller: _descriptionController,
                      maxLength: 300,
                      validator: (String? value) =>
                          value == null || value.isEmpty
                              ? 'Please enter a description'
                              : null,
                    ),

                    CustomDropdownWidget(
                      caption: 'Select Category *',
                      hintText: 'Choose a category',
                      items: _categories,
                      iconName: 'assets/svgs/dropdown.svg',
                      initialValue: _selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: CountryListPick(
                        appBar: AppBar(
                          leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon:
                                SvgPicture.asset('assets/svgs/backbutton.svg'),
                          ),
                          centerTitle: true,
                          title: const Text('Select Location',
                              textAlign: TextAlign.center),
                        ),
                        initialSelection: country.isEmpty
                            ? shopController.shop!.location
                            : country,
                        pickerBuilder:
                            (BuildContext context, CountryCode? countryCode) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(radiusValue),
                            ),
                            child: CustomTextWidget(
                              caption: 'Location *',
                              iconName: 'assets/svgs/nexticon.svg',
                              text: country.isEmpty
                                  ? shopController.shop!.location
                                  : country,
                            ),
                          );
                        },
                        onChanged: (CountryCode? code) {
                          setState(() {
                            country = code!.name!;
                            currencyController.text =
                                '${currencyValues[code.name.toString()]}';
                          });
                        },
                        useSafeArea: false,
                      ),
                    ),

                    // Budget and Deadline Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildLabel('Budget (optional)',
                                        LucideIcons.dollarSign),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Row(
                                spacing: 10,
                                children: <Widget>[
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: CustomEditText(
                                      padding: 5,
                                      currencycontroller: currencyController,
                                      caption: 'Starting Price',
                                      iscurrencyfield: true,
                                      maxLength: 15,
                                      hintText: 'Enter price',
                                      controller: _startPriceController,
                                      inputType: TextInputType.number,
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomEditText(
                                      padding: 5,
                                      currencycontroller: currencyController,
                                      caption: ' Ending Price',
                                      iscurrencyfield: true,
                                      maxLength: 15,
                                      hintText: 'Enter price',
                                      controller: _endPriceController,
                                      inputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: _buildLabel(
                              'Deadline (optional)', Icons.calendar_today),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _selectDate,
                          child: CustomTextWidget(
                            padding: 15,
                            textpadding: 15,
                            hashint: true,
                            caption: 'When do you need responses by?',
                            iconName: 'assets/svgs/dropdown.svg',
                            text: _selectedDeadline == null
                                ? 'Select date'
                                : DateFormat('EEEE dd MMMM, yyyy')
                                    .format(_selectedDeadline!),
                          ),
                        ),
                      ],
                    ),

                    // Attachments
                    _buildAttachmentSection(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColorLT,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          isSubmitting ? 'Submitting...' : 'Post Request',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAttachmentSection() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLabel('Attachments (optional)', LucideIcons.file),
              Text(
                'Upload specs, images, or sample references (max 5 files)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: InkWell(
            onTap: _attachments.length < 5 ? _pickFiles : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  Icon(LucideIcons.uploadCloud,
                      size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Drag & drop files here',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'or click to browse',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_attachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attachments.length,
              itemBuilder: (BuildContext context, int index) {
                final PlatformFile file = _attachments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.description, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(file.name, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(file.size / 1024).toStringAsFixed(1)} KB',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removeFile(index),
                        iconSize: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          text,
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
