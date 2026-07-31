import 'dart:convert';
import 'dart:io';

import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Result of the apply sheet: the uploaded CV, if the applicant attached one.
class JobApplication {
  const JobApplication({this.cvUrl, this.cvName});

  final String? cvUrl;
  final String? cvName;

  bool get hasCv => cvUrl != null && cvUrl!.isNotEmpty;
}

/// Asks the applicant for an optional CV before opening the chat with the
/// job poster. Returns null if they backed out.
Future<JobApplication?> showApplyWithCvSheet(BuyerRequestModel request) {
  return Get.bottomSheet<JobApplication>(
    _ApplyWithCvSheet(request: request),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class _ApplyWithCvSheet extends StatefulWidget {
  const _ApplyWithCvSheet({required this.request});

  final BuyerRequestModel request;

  @override
  State<_ApplyWithCvSheet> createState() => _ApplyWithCvSheetState();
}

class _ApplyWithCvSheetState extends State<_ApplyWithCvSheet> {
  PlatformFile? _cv;
  bool _sending = false;

  static const List<String> _allowedExtensions = <String>[
    'pdf',
    'doc',
    'docx',
    'rtf',
    'txt',
  ];

  /// 10 MB — keeps uploads within what the upload endpoint reliably accepts.
  static const int _maxBytes = 10 * 1024 * 1024;

  Future<void> _pickCv() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );

    if (result == null || result.files.isEmpty) return;

    final PlatformFile file = result.files.first;
    if (file.size > _maxBytes) {
      Get.snackbar('File too large', 'Please choose a CV under 10MB.');
      return;
    }

    setState(() => _cv = file);
  }

  /// Uploads the CV (if any) and closes the sheet with the result.
  Future<void> _submit() async {
    setState(() => _sending = true);

    String? url;
    if (_cv != null) {
      url = await _uploadCv(_cv!);
      if (url == null) {
        // Upload failed — keep the sheet open so the applicant can retry or
        // send without the CV rather than silently losing the attachment.
        if (mounted) setState(() => _sending = false);
        return;
      }
    }

    Get.back<JobApplication>(
      result: JobApplication(cvUrl: url, cvName: _cv?.name),
    );
  }

  Future<String?> _uploadCv(PlatformFile file) async {
    try {
      File? toUpload;

      if (file.path != null && file.path!.isNotEmpty) {
        toUpload = File(file.path!);
      } else if (file.bytes != null) {
        final Directory temp = Directory.systemTemp;
        toUpload = File(
          '${temp.path}/${DateTime.now().millisecondsSinceEpoch}_${file.name}',
        );
        await toUpload.writeAsBytes(file.bytes!);
      }

      if (toUpload == null) {
        Get.snackbar('Upload failed', 'Could not read ${file.name}.');
        return null;
      }

      final dynamic result = await ApiService.uploadFile(toUpload);

      if (file.path == null && await toUpload.exists()) {
        await toUpload.delete();
      }

      if (result is Map && result['success'] == true) {
        final String url =
            (result['fileUrl'])?.toString() ?? jsonEncode(result);
        return url.isEmpty ? null : url;
      }

      Get.snackbar('Upload failed', 'Could not upload ${file.name}.');
      return null;
    } catch (e) {
      Get.snackbar('Upload failed', e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Apply for this job',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            widget.request.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 18),
          const Text(
            'Attach your CV (optional)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (_cv == null)
            InkWell(
              onTap: _sending ? null : _pickCv,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: backgroundcolorinterface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: const <Widget>[
                    Icon(Icons.upload_file, color: Colors.black54),
                    SizedBox(height: 6),
                    Text(
                      'Choose a file',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'PDF or Word, up to 10MB',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundcolorinterface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.description_outlined,
                      color: primaryColorLT),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _cv!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        _sending ? null : () => setState(() => _cv = null),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColorLT,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _sending ? null : _submit,
              child: _sending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _cv == null ? 'Apply without CV' : 'Send Application',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'This opens a chat with the job poster.',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
