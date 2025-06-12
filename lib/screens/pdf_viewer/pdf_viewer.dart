import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:path_provider/path_provider.dart';

class PdfFullScreenViewer extends StatefulWidget {
  final Uint8List pdfBytes;

  const PdfFullScreenViewer({Key? key, required this.pdfBytes}) : super(key: key);

  @override
  State<PdfFullScreenViewer> createState() => _PdfFullScreenViewerState();
}

class _PdfFullScreenViewerState extends State<PdfFullScreenViewer> {
  String? _localPdfPath;
  int _pages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String? _errorMessage;

  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _savePdfFile();
  }

  Future<void> _savePdfFile() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp.pdf');
      await file.writeAsBytes(widget.pdfBytes);
      setState(() {
        _localPdfPath = file.path;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error saving PDF: $e";
      });
    }
  }

  void _goToPage(int offset) {
    if (_pdfViewController != null) {
      final target = _currentPage + offset;
      if (target >= 0 && target < _pages) {
        _pdfViewController!.setPage(target);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _localPdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          PDFView(
            filePath: _localPdfPath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                this._pages = _pages!;
                _isReady = true;
              });
            },
            onViewCreated: (controller) {
              _pdfViewController = controller;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page ?? 0;
              });
            },
            onError: (error) {
              setState(() {
                _errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                _errorMessage = 'Page $page error: $error';
              });
            },
          ),
          if (_isReady)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40.h,
                width: 40.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBgColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                              // Set custom radius here
                            ),
                            side: BorderSide(color: Colors.transparent, width: 1), // Border color and width
                          ),
                        ),
                        onPressed: _currentPage > 0
                            ? () => _goToPage(-1)
                            : null,
                        child: Icon(context.watchLang.currentLang == "ar" ? LucideIcons.chevronRight : LucideIcons.chevronLeft, size: 25, color: AppColors.whiteColor),
                      ),
                    ),
                    Text(
                      '${context.watchLang.translate(AppLanguageText.page)} ${_currentPage + 1} ${context.watchLang.translate(AppLanguageText.of)} $_pages',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40.h,
                      width: 40.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBgColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                              // Set custom radius here
                            ),
                            side: BorderSide(color: Colors.transparent, width: 1), // Border color and width
                          ),
                        ),
                        onPressed: _currentPage < _pages - 1
                            ? () => _goToPage(1)
                            : null,
                        child: Icon(context.watchLang.currentLang == "ar" ? LucideIcons.chevronLeft : LucideIcons.chevronRight, size: 25, color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
