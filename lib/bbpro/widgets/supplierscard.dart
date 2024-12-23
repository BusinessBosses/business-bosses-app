import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/supplier_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_supplier.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersCard extends StatefulWidget {
  final Vendor supplier;
  final bool? status;
  final Function()? onChangeSuppliersStatus;
  final Function()? onTap;

  const SuppliersCard({
    Key? key,
    required this.supplier,
    this.status,
    this.onChangeSuppliersStatus,
    this.onTap,
  }) : super(key: key);

  @override
  State<SuppliersCard> createState() => _SuppliersCardState();
}

class _SuppliersCardState extends State<SuppliersCard> {
  final ShopController shopController = Get.find();
  void _onEdit() {
    Get.to(
      () => AddSupplier(
        supplier: widget.supplier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(radius),
            color: Colors.white),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Image.network(
                widget.supplier.images.isNotEmpty == true
                    ? widget.supplier.images[0]
                    : '',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Icon(
                    Icons.shop_outlined,
                    size: 64,
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.supplier.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: textColor.withAlpha(200)),
            ),
            Text(
              widget.supplier.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              widget.supplier.location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: MCustomButton(
                      buttonType: ButtonType.outline,
                      strokeColor: proprimaryColor,
                      onPressed: widget.onChangeSuppliersStatus,
                      height: 36.0,
                      child: const Text(
                        'Contact',
                        style: TextStyle(color: proprimaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OptionsButton(
                  item: widget.supplier,
                  onEdit: _onEdit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Delete Supplier',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this supplier?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final bool delete =
                  await shopController.deleteSupplier(widget.supplier.id);
              if (delete) {
                showSnackbar(message: 'Supplier deleted successfully!');
              } else {
                showSnackbar(message: 'Error deleting supplier!', error: true);
              }
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
