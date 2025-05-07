import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class PDFScreen extends StatefulWidget {
  final String url;
  final String filename;

  const PDFScreen({super.key, required this.url, required this.filename});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late Future<PdfDocument> _pdfDocument;
  late PdfController _pdfController;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _pdfDocument = _loadPdf(widget.url);
    _pdfController = PdfController(document: _pdfDocument);
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

  Future<PdfDocument> _loadPdf(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final Uint8List pdfData = response.bodyBytes;
        return PdfDocument.openData(pdfData);
      } else {
        throw Exception('HTTP ${response.statusCode} — Failed to download PDF');
      }
    } catch (e) {
      debugPrint('Failed to load PDF: $e');
      rethrow;
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
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: Text(widget.filename, textAlign: TextAlign.center),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: backgroundColor,
            height: double.infinity,
            child: FutureBuilder<PdfDocument>(
              future: _pdfDocument,
              builder:
                  (BuildContext context, AsyncSnapshot<PdfDocument> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColorLT),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load PDF'));
                } else if (snapshot.hasData) {
                  return PdfView(
                    controller: _pdfController,
                    scrollDirection: Axis.vertical,
                  );
                } else {
                  return const Center(child: Text('No PDF data available'));
                }
              },
            ),
          ),

          // “Scroll down” tip overlay
          if (_isVisible)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text('Scroll down'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
