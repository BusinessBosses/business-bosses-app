import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/listing_success_screen.dart';
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
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddBuyerRequests extends StatefulWidget {
  final BuyerRequestModel? request;
  const AddBuyerRequests({super.key, this.request});

  @override
  State<AddBuyerRequests> createState() => _AddBuyerRequestsState();
}

class _AddBuyerRequestsState extends State<AddBuyerRequests> {
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
  /// The picker was dropped from the job form, but the API still expects a
  /// request_type, so every job posts as a service-provider request.
  static const String _requestType = 'I need a service provider';
  DateTime? _selectedDeadline;
  final List<PlatformFile> _attachments = <PlatformFile>[];
  List<String> _existingAttachments = <String>[];

  bool _isExpanded = false;

  final List<String> _categories = <String>[
    'Agriculture, Food & Beverage',
    'Learning & Education',
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
    'Business Services & Consulting'
  ];

  @override
  void initState() {
    super.initState();
    currencyController.text = 'USD';

    if (widget.request != null) {
      final BuyerRequestModel req = widget.request!;
      _titleController.text = req.title;
      _descriptionController.text = req.description;
      _startPriceController.text = req.budgetStart.toString();
      _endPriceController.text = req.budgetEnd.toString();
      _selectedCategory = req.category;
      country = req.user.location ?? '';
      _selectedDeadline =
          req.deadline.isNotEmpty ? DateTime.tryParse(req.deadline) : null;
      currencyController.text = 'USD';
      _existingAttachments =
          List<String>.from(widget.request?.attachments ?? <dynamic>[]);
    } else {
      // Create mode: pre-fill industry/country from the user's profile.
      final String pIndustry = (profileController.myProfile.industry ?? '').trim();
      final String pLocation = (profileController.myProfile.location ?? '').trim();
      _selectedCategory = pIndustry;
      country = pLocation.isNotEmpty
          ? pLocation
          : (shopController.shop?.location ?? '');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startPriceController.dispose();
    _endPriceController.dispose();
    currencyController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    if ((_existingAttachments.length + _attachments.length) >= 5) return;

    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: <String>['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        final int remainingSlots =
            5 - (_existingAttachments.length + _attachments.length);
        _attachments.addAll(result.files.take(remainingSlots));
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
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    buyerRequestController.error(false);

    final Map<String, dynamic> body = <String, dynamic>{
      'request_type': _requestType,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      // A job carries a single budget figure. The API still models a range, so
      // both ends are sent as the same amount.
      'budget_start': _startPriceController.text.isEmpty
          ? null
          : _startPriceController.text,
      'budget_end': _startPriceController.text.isEmpty
          ? null
          : _startPriceController.text,
      'deadline': _selectedDeadline?.toIso8601String(),
      'location':
          country.isEmpty ? (shopController.shop?.location ?? '') : country,
    };

    if (widget.request != null) {
      await buyerRequestController.updateBuyerRequest(
        widget.request!.id!,
        body,
        attachments: _attachments,
        existingAttachments: _existingAttachments,
      );
    } else {
      await buyerRequestController.addBuyerRequest(
        body,
        attachments: _attachments,
      );
    }

    if (!buyerRequestController.error.value) {
      if (mounted) {
        showSnackbar(
          message:
              'Job ${widget.request == null ? 'posted' : 'edited'} successfully!',
        );
      }
      if (widget.request == null) {
        // Only show success screen for NEW requests
        Get.to(() => ListingSuccessScreen(
              isBuyerRequest: true,
              industry: _selectedCategory,
              location: country.isEmpty
                  ? (shopController.shop?.location ?? '')
                  : country,
            ));
      } else {
        Navigator.pop(Get.context!);
      }
    } else {
      showSnackbar(
          message:
              'Failed to ${widget.request != null ? 'edit' : 'post'} job.',
          error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Post a Job',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Get your work done faster, with the best talent.',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 0),
                CustomEditText(
                  caption: 'Job Title *',
                  maxLength: 30,
                  hintText: 'Enter the name of the job or task',
                  controller: _titleController,
                  validator: (String? value) =>
                      value == null || value.trim().isEmpty
                          ? 'Title is required'
                          : null,
                ),
                CustomEditText(
                  caption: 'Job Description *',
                  hintText:
                      'Enter the job description, qualification or skills required for the job',
                  controller: _descriptionController,
                  maxLength: 300,
                  validator: (String? value) => value == null || value.isEmpty
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
                        icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                      ),
                      centerTitle: true,
                      title: const Text(
                        'Select Location',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    initialSelection: country.isEmpty
                        ? (shopController.shop?.location ?? 'UK')
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
                          iconcolor: const Color(0xFFFF1E39),
                          text: country.isEmpty
                              ? (shopController.shop?.location ??
                                  'United Kingdom')
                              : country,
                        ),
                      );
                    },
                    onChanged: (CountryCode? code) {
                      setState(() {
                        country = code!.name!;
                        currencyController.text =
                            currencyValues[code.name.toString()] ?? 'USD';
                      });
                    },
                    useSafeArea: false,
                  ),
                ),
                _buildAttachmentSection(),
                const SizedBox(
                  width: double.infinity,
                  height: 1.5,
                  child: ColoredBox(color: backgroundcolorinterface),
                ),
                ExpansionTile(
                  shape: const Border(),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _isExpanded = expanded;
                    });
                  },
                  trailing: _isExpanded
                      ? SvgPicture.asset(
                          'assets/svgs/dropdownexpansionup.svg',
                        )
                      : SvgPicture.asset(
                          'assets/svgs/dropdownexpansion.svg',
                        ),
                  title: RichText(
                    text: const TextSpan(
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Additional Information',
                          style: TextStyle(color: textColor),
                        ),
                        TextSpan(
                          text: ' (Optional)',
                          style: TextStyle(color: hintColor),
                        ),
                      ],
                    ),
                  ),
                  children: <Widget>[
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
                                children: <Widget>[
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: CustomEditText(
                                      padding: 5,
                                      currencycontroller: currencyController,
                                      caption: 'Budget',
                                      iscurrencyfield: true,
                                      maxLength: 15,
                                      hintText: 'Enter amount',
                                      controller: _startPriceController,
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
                    const SizedBox(height: 20),
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
                            caption: 'When do you need applications by?',
                            iconName: 'assets/svgs/dropdown.svg',
                            text: _selectedDeadline == null
                                ? 'Select date'
                                : DateFormat('EEEE dd MMMM, yyyy')
                                    .format(_selectedDeadline!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),

                  /// ONLY OBSERVING THIS PART
                  child: Obx(() {
                    return CustomButton(
                      buttonType: ButtonType.elevated,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      onPressed: _handleSubmit,
                      isProcessing: buyerRequestController.loading.value,
                      label: widget.request == null
                          ? 'Post Job'
                          : 'Edit Job',
                    );
                  }),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
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
                'Upload images, or files (max 5 files)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_existingAttachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _existingAttachments.length,
              itemBuilder: (BuildContext context, int index) {
                final String url = _existingAttachments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.attach_file, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          url.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _existingAttachments.removeAt(index);
                          });
                        },
                        iconSize: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: GestureDetector(
            onTap: (_existingAttachments.length + _attachments.length) < 5
                ? _pickFiles
                : null,
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
                      'Add Attachment',
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
