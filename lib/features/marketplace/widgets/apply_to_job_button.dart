import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/apply_with_cv_sheet.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Applying to a job, in one place.
///
/// The job detail lives in four screens (marketplace list, details sheet, my
/// profile, public profile) and each used to carry its own copy of the button
/// and navigation — which is how they drifted apart, some still gating on
/// having a shop and reading "Send Proposal". Use [applyToJob] for the flow and
/// [ApplyToJobButton] for the standard button.
///
/// Anyone can apply; no shop required. The CV sheet runs first so the applicant
/// can optionally attach one, and returns null if they back out.
Future<void> applyToJob(BuyerRequestModel request) async {
  final JobApplication? application = await showApplyWithCvSheet(request);
  if (application == null) return;

  Get.to(
    () => const ChatRoomScreen(frommarketplace: false, fromBuyerRequest: true),
    arguments: <String, Object?>{
      'user': request.user,
      'buyerRequest': request,
      'cvUrl': application.cvUrl,
      'cvName': application.cvName,
    },
  );
}

/// Full-width "Apply with your CV" action shown on a job detail.
class ApplyToJobButton extends StatelessWidget {
  const ApplyToJobButton({super.key, required this.request});

  final BuyerRequestModel request;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => applyToJob(request),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorLT,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Apply with your CV',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
