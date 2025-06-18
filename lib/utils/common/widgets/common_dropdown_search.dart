import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common_validation.dart';

class CustomSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String fieldName;
  final String hintText;
  final String Function(T, String) itemLabel;
  final void Function(T?)? onSelected;
  final String currentLang; // Not nullable now
  final TextEditingController controller;
  final bool skipValidation;
  final bool isEnable;
  final String? Function(String?)? validator;
  final String? toolTipContent;
  final bool isSmallFieldFont;
  final T? initialValue;

  const CustomSearchDropdown({
    super.key,
    required this.items,
    required this.controller,
    required this.fieldName,
    required this.hintText,
    required this.itemLabel,
    required this.currentLang, // required
    this.onSelected,
    this.isEnable = true,
    this.skipValidation = false,
    this.validator,
    this.toolTipContent,
    this.isSmallFieldFont = false,
    this.initialValue,
  });

  @override
  State<CustomSearchDropdown<T>> createState() => _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T> extends State<CustomSearchDropdown<T>> with WidgetsBindingObserver {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  double _keyboardHeight = 0.0;
  bool _isKeyboardOpen = false;
  bool _isFiltering = false;



  T? _selectedItem;
  OverlayEntry? _overlayEntry;
  bool _suppressControllerListener = false;
  List<T> filteredItems = [];

  late final VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
    // 1) Find initial selected item from initialValue or controller text
    if (widget.initialValue != null) {
      _selectedItem = _findMatchingItemByEqualityOrEnglishLabel(widget.initialValue!);
    } else if (widget.controller.text.isNotEmpty) {
      _selectedItem = _findItemMatchingText(widget.controller.text);
    } else {
      _selectedItem = null;
    }

    // 2) Set controller text to the label of the selected item, if any
    widget.controller.text = _selectedItem != null
        ? widget.itemLabel(_selectedItem!, widget.currentLang)
        : '';

    // 3) Initially all items are visible
    filteredItems = widget.items;

    // 4) Setup controller listener for filtering items as user types
    _controllerListener = () {
      if (_suppressControllerListener) return;

      final query = widget.controller.text.trim().toLowerCase();

      _isFiltering = true;  // <---- set true before filtering

      setState(() {
        filteredItems = query.isEmpty
            ? widget.items
            : widget.items.where((item) {
          final label = widget.itemLabel(item, widget.currentLang).toLowerCase().trim();
          return label.contains(query);
        }).toList();
      });

      _isFiltering = false;  // <---- reset after filtering

      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    };

    widget.controller.addListener(_controllerListener);

    // 5) Setup focus listener to show/hide dropdown overlay
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Wait for keyboard to fully open and get accurate height
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted || !_focusNode.hasFocus) return;

          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          if (bottomInset > 0) {
            _keyboardHeight = bottomInset; // Save the height
          }

          _showOverlay();
        });
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final langChanged = oldWidget.currentLang != widget.currentLang;
    final initialChanged = oldWidget.initialValue != widget.initialValue;

    // If the initialValue changed, update selected item accordingly
    if (initialChanged) {
      try {
        _selectedItem = widget.items.firstWhere(
              (item) => item == widget.initialValue,
        );
      } catch (_) {
        _selectedItem = null;
      }

      _suppressControllerListener = true;
      widget.controller.text = _selectedItem != null
          ? widget.itemLabel(_selectedItem!, widget.currentLang)
          : '';
      _suppressControllerListener = false;

      setState(() {
        filteredItems = widget.items;
      });
    }

    // If language changed, update the controller text from selected item label in new language
    if (langChanged) {
      if (_selectedItem != null) {
        _suppressControllerListener = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          widget.controller.text = widget.itemLabel(_selectedItem!, widget.currentLang);
          _suppressControllerListener = false;
        });
      } else {
        final currentText = widget.controller.text.toLowerCase();

        T? found;
        for (final item in widget.items) {
          final label = widget.itemLabel(item, oldWidget.currentLang).toLowerCase();
          if (label == currentText) {
            found = item;
            break;
          }
        }

        if (found != null) {
          _selectedItem = found;
          _suppressControllerListener = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            widget.controller.text = widget.itemLabel(_selectedItem!, widget.currentLang);
            _suppressControllerListener = false;
          });
        }
      }
    }
  }

  T? _findMatchingItemByEqualityOrEnglishLabel(T initialValue) {
    try {
      return widget.items.firstWhere((item) => item == initialValue);
    } catch (_) {}

    try {
      final englishLabel = widget.itemLabel(initialValue, 'en').toLowerCase();
      return widget.items.firstWhere(
            (item) => widget.itemLabel(item, 'en').toLowerCase() == englishLabel,
      );
    } catch (_) {}

    return null;
  }

  /// Finds item that matches the exact text label (case insensitive)
  T? _findItemMatchingText(String text) {
    final lowerText = text.toLowerCase();
    for (final item in widget.items) {
      if (widget.itemLabel(item, widget.currentLang).toLowerCase() == lowerText) {
        return item;
      }
    }
    return null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_controllerListener);
    _removeOverlay();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _removeOverlay();

    // Don't reset filteredItems here! _controllerListener handles filtering
    // Just show overlay as is.

    final overlay = Overlay.of(context, rootOverlay: false);
    if (overlay != null) {
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
    }
  }


  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        filteredItems = widget.items; // Reset to full list
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted || !_focusNode.hasFocus) return;
        _showOverlay();
      });
    } else {
      _removeOverlay();

      // 🔥 Clear field if no item matches current text
      final text = widget.controller.text.trim();
      final match = _findItemMatchingText(text);
      if (text.isNotEmpty && match == null) {
        _suppressControllerListener = true;
        widget.controller.clear();
        _selectedItem = null;
        _suppressControllerListener = false;
        widget.onSelected?.call(null);
      }
    }
  }



  @override
  void didChangeMetrics() {
    final viewInsets = WidgetsBinding.instance.window.viewInsets;
    final newKeyboardHeight = viewInsets.bottom / WidgetsBinding.instance.window.devicePixelRatio;

    setState(() {
      _keyboardHeight = newKeyboardHeight;
      _isKeyboardOpen = _keyboardHeight > 100;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    const dropdownMaxHeight = 200.0;

    const itemHeight = 48.0; // adjust as per your ListTile height

    final dropdownHeight = filteredItems.isEmpty
        ? itemHeight
        : (filteredItems.length * itemHeight).clamp(0, dropdownMaxHeight).toDouble();

    const dropdownSpacing = 5.0;

    final availableHeight = _isKeyboardOpen
        ? screenHeight - _keyboardHeight
        : screenHeight;

    final showAbove = offset.dy + size.height + dropdownSpacing + dropdownMaxHeight > availableHeight;

    final dropdownOffset = showAbove
        ? Offset(0, -dropdownMaxHeight - dropdownSpacing)
        : Offset(0, size.height + dropdownSpacing);

    final dropdownRect = Rect.fromLTWH(
      offset.dx,
      showAbove
          ? offset.dy - dropdownMaxHeight - dropdownSpacing
          : offset.dy + size.height + dropdownSpacing,
      size.width,
      dropdownMaxHeight,
    );

    final fieldRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);

    return OverlayEntry(
      builder: (context) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          if (!fieldRect.contains(event.position) &&
              !dropdownRect.contains(event.position)) {
            _removeOverlay();
            FocusScope.of(context).unfocus();
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          }
        },
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: dropdownOffset,
              child: SizedBox(
                width: size.width,
                child: Material(
                  elevation: 4,
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: SizedBox(
                        height: dropdownMaxHeight,
                        child: filteredItems.isEmpty
                        ? SizedBox(
                        height: dropdownHeight,
                        child: Center(
                          child: Text(
                            context.readLang.translate(AppLanguageText.noOptionFound),
                            style: AppFonts.textRegular17.copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                          : ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: filteredItems.map((item) {
                        final isSelected = item == _selectedItem;

                        return ListTile(
                          dense: true,
                          title: Text(widget.itemLabel(item, widget.currentLang), style: AppFonts.textRegular17),
                          trailing: isSelected
                              ? const Icon(Icons.check,
                              color: AppColors.primaryColor, size: 20)
                              : null,
                          onTap: () {
                            _selectedItem = item;
                            widget.controller.text =
                                widget.itemLabel(item, widget.currentLang);
                            widget.onSelected?.call(item);
                            _removeOverlay();
                            FocusScope.of(context).unfocus();
                            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                          },
                        );
                      }).toList(),
                    ),
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
              Text(widget.fieldName, style: (widget.isSmallFieldFont ? AppFonts.textRegular14 : AppFonts.textRegular17)),
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
              setState(() {
                filteredItems = widget.items;
              });
              _showOverlay(); // Always show full list when tapped
            },
            style: isSmall && isDisabled
                ? AppFonts.textRegularGrey14
                : isSmall
                ? AppFonts.textRegular14
                : isDisabled
                ? AppFonts.textRegularGrey17
                : AppFonts.textRegular17,
            validator: widget.skipValidation
                ? null
                : widget.validator ??
                    (value) =>
                    CommonValidation().commonValidator(context, value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: widget.isEnable,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: isSmall
                  ? AppFonts.textRegularGrey14
                  : AppFonts.textRegularGrey16,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              filled: true,
              fillColor: isDisabled
                  ? AppColors.disabledFieldColor
                  : AppColors.whiteColor,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _suppressControllerListener = true;
                          _selectedItem = null;
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
                        child: Icon(LucideIcons.x,
                            size: 20, color: AppColors.greyColor),
                      ),
                    Icon(LucideIcons.chevronsUpDown,
                        size: 20, color: AppColors.greyColor),
                  ],
                ),
              ),
              border: _defaultBorder(),
              enabledBorder: _defaultBorder(),
              focusedBorder: _defaultBorder(),
              errorBorder: _defaultBorder(),
              focusedErrorBorder: _defaultBorder(),
              disabledBorder: _defaultBorder(),
              errorStyle: const TextStyle(color: AppColors.underscoreColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _defaultBorder() {
    return OutlineInputBorder(
      borderSide:
      const BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
      borderRadius: BorderRadius.circular(15),
    );
  }
}

