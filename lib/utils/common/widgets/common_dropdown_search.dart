import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/utils/common/common_validation.dart';

class CustomSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String fieldName;
  final String hintText;
  final String Function(T) itemLabel;
  final void Function(T?)? onSelected;
  final TextEditingController controller;
  final bool skipValidation;
  final String? Function(String?)? validator;
  final String? toolTipContent;
  final bool isSmallFieldFont;

  const CustomSearchDropdown({
    super.key,
    required this.items,
    required this.controller,
    required this.fieldName,
    required this.hintText,
    required this.itemLabel,
    this.onSelected,
    this.skipValidation = false,
    this.validator,
    this.toolTipContent,
    this.isSmallFieldFont = false,
  });

  @override
  State<CustomSearchDropdown<T>> createState() =>
      _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T> extends State<CustomSearchDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  List<T> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;

    widget.controller.addListener(() {
      final query = widget.controller.text.toLowerCase();
      setState(() {
        filteredItems =
            widget.items
                .where(
                  (item) =>
                      widget.itemLabel(item).toLowerCase().contains(query),
                )
                .toList();
      });
      _showOverlay();
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    const double dropdownMaxHeight = 200;
    const double dropdownSpacing = 5;

    final showAbove =
        offset.dy + size.height + dropdownSpacing + dropdownMaxHeight >
        screenHeight;
    final dropdownOffset =
        showAbove
            ? Offset(0, -dropdownMaxHeight - dropdownSpacing)
            : Offset(0, size.height + dropdownSpacing);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: dropdownOffset,
              child: Material(
                color: AppColors.whiteColor,
                elevation: 4,
                borderRadius: BorderRadius.circular(15),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: dropdownMaxHeight),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children:
                        filteredItems.map((item) {
                          return ListTile(
                            dense: true,
                            minVerticalPadding: 0,
                            title: Text(
                              widget.itemLabel(item),
                              style: AppFonts.textRegular17,
                            ),
                            onTap: () {
                              widget.controller.text = widget.itemLabel(item);
                              widget.onSelected?.call(item);
                              _removeOverlay();
                              FocusScope.of(context).unfocus();
                            },
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.fieldName, style: widget.isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular18),
              const SizedBox(width: 3),
              if (!widget.skipValidation)
                const Text(
                  "*",
                  style: TextStyle(fontSize: 15, color: AppColors.textRedColor),
                ),
              if (widget.toolTipContent != null) ...[
                const SizedBox(width: 3),
                Tooltip(
                  message: widget.toolTipContent!,
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: widget.isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular17,
            validator: widget.skipValidation ? null : widget.validator ?? CommonValidation().commonValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.isSmallFieldFont ? AppFonts.textRegularGrey14 : AppFonts.textRegularGrey16,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 18,
              ),
              filled: true,
              fillColor: AppColors.whiteColor,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Clear icon
                    if (widget.controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          widget.controller.clear();
                          widget.onSelected?.call(null);
                          setState(() {
                            filteredItems = widget.items;
                          });
                          _removeOverlay();
                        },
                        child: Icon(
                          LucideIcons.x,
                          size: 20,
                          color: AppColors.greyColor,
                        ),
                      ),
                    // Dropdown icon
                    Icon(
                      LucideIcons.chevronsUpDown,
                      size: 20,
                      color: AppColors.greyColor,
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
