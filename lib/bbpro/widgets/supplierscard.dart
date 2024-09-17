import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/expandedsupplierspage.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersCard extends StatefulWidget {
  final SuppliersModel? supplier;
  final bool? status;
  final Function()? onChangeSuppliersStatus;
  final Function()? onTap;

  const SuppliersCard({
    Key? key,
    this.supplier,
    this.status,
    this.onChangeSuppliersStatus,
    this.onTap,
  }) : super(key: key);

  @override
  State<SuppliersCard> createState() => _SuppliersCardState();
}

class _SuppliersCardState extends State<SuppliersCard> {
  void _onEdit() {
    // Implement edit functionality
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.supplier != null) {
          Get.to(() => ExpandedSuppliersPage(supplier: widget.supplier!));
        }
      },
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: Colors.white),
        child: Column(
          children: <Widget>[
            if (widget.supplier?.isVerified ?? false)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(35),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Verified',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Image.network(
                widget.supplier?.images?.isNotEmpty == true
                    ? widget.supplier!.images![0]
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
              widget.supplier?.name ?? 'Unknown Supplier',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: textColor.withAlpha(200)),
            ),
            Text(
              widget.supplier?.description ?? 'No description available',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              widget.supplier?.location ?? 'Unknown location',
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
}
