import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class AddPackageBottomSheet extends StatefulWidget {
  final TextEditingController packageNameController;
  final TextEditingController expenseController;
  final TextEditingController? currencyController;
  final VoidCallback onPressed;
  const AddPackageBottomSheet({
    super.key,
    required this.packageNameController,
    required this.expenseController,
    required this.onPressed,
    this.currencyController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddPackageBottomSheetState createState() => _AddPackageBottomSheetState();
}

class _AddPackageBottomSheetState extends State<AddPackageBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _packageNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packageNameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _packageNameFocusNode.dispose();
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
                        focusNode: _packageNameFocusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'Write package name here...',
                          filled: false,
                          fillColor: Colors.grey.shade100,
                        ),
                        maxLength: 50,
                        controller: widget.packageNameController,
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
                currencycontroller: widget.currencyController,
                iscurrencyfield: true,
                currencyfieldcolor: probackgroundColor,
                backgroundcolor: prosemibackColor,
                caption: 'Price',
                hintText: '0.00',
                inputType: TextInputType.number,
                controller: widget.expenseController,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
