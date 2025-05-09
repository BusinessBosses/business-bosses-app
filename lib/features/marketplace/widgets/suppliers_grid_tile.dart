import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/expandedsupplierspage.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

class SuppliersGridTile extends StatefulWidget {
  final SuppliersModel supplier;
  final bool? status;
  final Function()? onChangeSuppliersStatus;
  final Function()? onTap;

  @override
  State<SuppliersGridTile> createState() => _SuppliersGridTileState();

  const SuppliersGridTile({
    super.key,
    required this.supplier,
    this.status,
    this.onChangeSuppliersStatus,
    this.onTap,
  });
}

class _SuppliersGridTileState extends State<SuppliersGridTile> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ProfileController profileController = Get.find();
    return InkWell(
      onTap: () {
        widget.supplier.isBiz!
            ? Get.to(
                () => PublicProfileScreen(
                  currentIndex: 1,
                ),
                arguments: widget.supplier.user,
              )
            : Get.to(() => ExpandedSuppliersPage(supplier: widget.supplier));
      },
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: Colors.white),
        child: Column(
          children: <Widget>[
            if (widget.supplier.isVerified)
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
                widget.supplier.images!.isNotEmpty
                    ? widget.supplier.images![0]
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
              widget.supplier.location!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12.0),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: MCustomButton(
                buttonType: ButtonType.outline,
                onPressed: widget.supplier.isBiz!
                    ? () {
                        Get.to(
                          () => PublicProfileScreen(
                            currentIndex: 1,
                          ),
                          arguments: widget.supplier.user,
                        );
                      }
                    : widget.onChangeSuppliersStatus,
                height: 36.0,
                width: 120.0,
                child: const Text(
                  'Contact',
                  style: TextStyle(color: primaryColorLT),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
