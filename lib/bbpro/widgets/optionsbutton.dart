import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final bool? isExpanded;
  final bool? isEdit;
  final dynamic item;
  final bool? isBoost;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;
  final VoidCallback? onBoost;

  const OptionsButton({
    super.key,
    this.padding,
    this.borderColor,
    this.isExpanded = false,
    this.isEdit = true,
    this.item,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.onBoost,
    this.isBoost,
  });

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry<String>> myPopupMore = <PopupMenuEntry<String>>[
      if (isExpanded == true)
        const PopupMenuItem<String>(
          value: 'View',
          child: Text(
            'View',
            style: bodyText2,
          ),
        ),
      if (isExpanded == true)
        const PopupMenuDivider(
          height: 0.0,
        ),
      if (isEdit == true)
        const PopupMenuItem<String>(
          value: 'Edit',
          child: Text(
            'Edit',
            style: bodyText2,
          ),
        ),
      if (isEdit == true)
        const PopupMenuDivider(
          height: 0.0,
        ),
      const PopupMenuItem<String>(
        value: 'Delete',
        child: Text(
          'Delete',
          style: bodyText2,
        ),
      ),
    ];

    return GestureDetector(
      onTap: () {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RenderBox button = context.findRenderObject() as RenderBox;
        final Offset offset = button.localToGlobal(Offset.zero);

        showMenu<String>(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          context: context,
          shadowColor: Colors.black54,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + button.size.height,
            overlay.size.width - offset.dx - button.size.width,
            overlay.size.height - offset.dy - button.size.height,
          ),
          items: myPopupMore,
        ).then((String? value) {
          if (value != null) {
            // Handle your popup item selection here
            if (value == 'View') {
              // View action
            } else if (value == 'Edit') {
              // Edit action
              if (onEdit != null) {
                onEdit!();
              }
            } else if (value == 'Delete') {
              // Delete action
              if (onDelete != null) {
                onDelete!();
              }
            }
          }
        });
      },
      child: Container(
        padding: padding ?? const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor ?? backgroundColor,
            width: 1,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.more_vert,
          ),
        ),
      ),
    );
  }
}
