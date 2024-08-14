import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddProjectBottomSheet extends StatefulWidget {
  final TextEditingController taskNameController;
  final TextEditingController expenseController;
  DateTime startDate;
  DateTime endDate;
  final VoidCallback onPressed;

  AddProjectBottomSheet({
    Key? key,
    required this.taskNameController,
    required this.expenseController,
    required this.startDate,
    required this.endDate,
    required this.onPressed,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProjectBottomSheetState createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State<AddProjectBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _taskNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskNameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _taskNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        focusNode: _taskNameFocusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'Write task here...',
                          filled: false,
                          fillColor: Colors.grey.shade100,
                        ),
                        maxLength: 50,
                        controller: widget.taskNameController,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onPressed,
                      child: CircleAvatar(
                        backgroundColor: proprimaryColor,
                        child:
                            SvgPicture.asset('assets/svgs/taskcheckmark.svg'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomEditText(
                backgroundcolor: prosemibackColor,
                caption: 'Expense',
                hintText: '\$0.00',
                controller: widget.expenseController,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != widget.startDate) {
                            setState(() {
                              widget.startDate = picked;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: prosemibackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    widget.startDate != null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(widget.startDate!)
                                        : 'Start Date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: widget.startDate != null
                                          ? textColor
                                          : hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.endDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != widget.endDate) {
                            setState(() {
                              widget.endDate = picked;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: prosemibackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    widget.endDate != null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(widget.endDate!)
                                        : 'End Date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: widget.endDate != null
                                          ? textColor
                                          : hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
