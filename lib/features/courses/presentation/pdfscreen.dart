import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class PDFScreen extends StatefulWidget {
  final String url;
  const PDFScreen({super.key, required this.url});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final PdfController _pdfController = PdfController(
    document: PdfDocument.openData(InternetFile.get(
        'https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf')),
  );

  // Future loadPdf() async {
  //   try {
  //     await rootBundle.load(widget.url);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // loadPdf();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loaderWidget = const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
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
        child: _pdfController == null
            ? loaderWidget
            : PdfView(controller: _pdfController),
      )),
    );
  }
}
