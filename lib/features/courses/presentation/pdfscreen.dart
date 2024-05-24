import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class PDFScreen extends StatefulWidget {
  final String url;

  const PDFScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late Future<PdfDocument> _pdfDocument;
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfDocument = _loadPdf(widget.url);
    _pdfController = PdfController(document: _pdfDocument);
  }

  Future<PdfDocument> _loadPdf(String url) async {
    try {
      final pdfData = await InternetFile.get(url);
      return PdfDocument.openData(pdfData);
    } catch (e) {
      debugPrint("Failed to load PDF: $e");
      throw Exception("Failed to load PDF");
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'File Viewer',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<PdfDocument>(
            future: _pdfDocument,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Failed to load PDF'),
                );
              } else if (snapshot.hasData) {
                return PdfView(controller: _pdfController);
              } else {
                return const Center(
                  child: Text('No PDF data available'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
