import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/utils/common_validation.dart';

class CustomSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String fieldName;
  final String hintText;
  final String Function(T) itemLabel;
  final void Function(T?)? onSelected;
  final TextEditingController controller;
  final bool skipValidation;
  final bool isEnable;
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
    this.isEnable = true,
    this.skipValidation = false,
    this.validator,
    this.toolTipContent,
    this.isSmallFieldFont = false,
  });

  @override
  State<CustomSearchDropdown<T>> createState() => _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T> extends State<CustomSearchDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  bool _suppressControllerListener = false;
  List<T> filteredItems = [];

  late final VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;

    _controllerListener = () {
      if (_suppressControllerListener) return;

      final query = widget.controller.text.toLowerCase();
      if (!mounted) return;

      setState(() {
        filteredItems = widget.items
            .where((item) => widget.itemLabel(item).toLowerCase().contains(query))
            .toList();
      });

      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    };

    widget.controller.addListener(_controllerListener);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          filteredItems = widget.items;
        });
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
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

    const dropdownMaxHeight = 200.0;
    const dropdownSpacing = 5.0;

    final showAbove = offset.dy + size.height + dropdownSpacing + dropdownMaxHeight > screenHeight;
    final dropdownOffset = showAbove
        ? Offset(0, -dropdownMaxHeight - dropdownSpacing)
        : Offset(0, size.height + dropdownSpacing);

    // Track the dropdown's full global rect
    final dropdownRect = Rect.fromLTWH(
      offset.dx,
      showAbove ? offset.dy - dropdownMaxHeight - dropdownSpacing : offset.dy + size.height + dropdownSpacing,
      size.width,
      dropdownMaxHeight,
    );

    // Track the main input field's global rect
    final fieldRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);

    return OverlayEntry(
      builder: (context) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          // Dismiss only if tap is outside both the input and dropdown
          if (!fieldRect.contains(event.position) && !dropdownRect.contains(event.position)) {
            _removeOverlay();
            FocusScope.of(context).unfocus();
          }
        },
        child: Stack(
          children: [
            Positioned(
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
                    constraints: const BoxConstraints(maxHeight: dropdownMaxHeight),
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(8),
                      thickness: 4,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: filteredItems.map((item) {
                        return ListTile(
                          dense: true,
                          minVerticalPadding: 0,
                          title: Text(widget.itemLabel(item), style: AppFonts.textRegular17),
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = widget.isSmallFieldFont;
    final isDisabled = !widget.isEnable;
    final textColor = !widget.isEnable
        ? (widget.isSmallFieldFont ? AppFonts.textRegularGrey14 : AppFonts.textRegularGrey17)
        : (widget.isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular17);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.fieldName, style: textColor),
              const SizedBox(width: 3),
              if (!widget.skipValidation)
                const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
              if (widget.toolTipContent != null) ...[
                const SizedBox(width: 3),
                Tooltip(
                  message: widget.toolTipContent!,
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.info_outline, size: 20, color: AppColors.primaryColor),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            onTap: () {
              if (_focusNode.hasFocus && filteredItems.length != widget.items.length) {
                setState(() {
                  filteredItems = widget.items;
                });
                _showOverlay();
              } else if (_focusNode.hasFocus) {
                _showOverlay();
              }
            },
            style: isSmall && isDisabled
                ? AppFonts.textRegularGrey14
                : isSmall
                ? AppFonts.textRegular14
                : isDisabled
                ? AppFonts.textRegularGrey17
                : AppFonts.textRegular17,
            validator: widget.skipValidation ? null : widget.validator ?? (value) => CommonValidation().commonValidator(context, value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: widget.isEnable,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: isSmall ? AppFonts.textRegularGrey14 : AppFonts.textRegularGrey16,
              contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
              filled: true,
              fillColor: isDisabled ? AppColors.disabledFieldColor : AppColors.whiteColor,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _suppressControllerListener = true;
                          widget.controller.clear();
                          _suppressControllerListener = false;

                          widget.onSelected?.call(null);
                          setState(() {
                            filteredItems = widget.items;
                          });
                          _removeOverlay();

                          if (_focusNode.hasFocus) {
                            _showOverlay();
                          }
                        },
                        child: Icon(LucideIcons.x, size: 20, color: AppColors.greyColor),
                      ),
                    Icon(LucideIcons.chevronsUpDown, size: 20, color: AppColors.greyColor),
                  ],
                ),
              ),
              border: _defaultBorder(),
              enabledBorder: _defaultBorder(),
              focusedBorder: _defaultBorder(),
              errorBorder: _defaultBorder(),
              focusedErrorBorder: _defaultBorder(),
              disabledBorder: _defaultBorder(),
              errorStyle: const TextStyle(color: AppColors.underscoreColor),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _defaultBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
