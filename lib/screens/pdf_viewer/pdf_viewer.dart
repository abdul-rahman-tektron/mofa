import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfFullScreenViewer extends StatefulWidget {
  final Uint8List pdfBytes; // Pass bytes directly instead of base64

  const PdfFullScreenViewer({Key? key, required this.pdfBytes}) : super(key: key);

  @override
  _PdfFullScreenViewerState createState() => _PdfFullScreenViewerState();
}

class _PdfFullScreenViewerState extends State<PdfFullScreenViewer> {
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(widget.pdfBytes),
        initialPage: 0,
      );
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("PDF Error: $e");
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
          ? const Center(child: Text('Failed to load PDF'))
          : PdfViewPinch(
        controller: _pdfController,
        scrollDirection: Axis.vertical,
        // pageSnapping: false,
        onDocumentError: (error) {
          debugPrint("PDF Rendering Error: $error");
        },
      ),
    );
  }
}