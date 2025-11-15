import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class PreMatchModal extends StatefulWidget {
  const PreMatchModal({super.key});

  @override
  State<PreMatchModal> createState() => _PreMatchModalState();
}

class _PreMatchModalState extends State<PreMatchModal> {
  final ProfileController profileController = Get.find();
  final MatchController matchController = Get.find();
  String? _selectedOption;
  bool isSubmitting = false;

  final List<Map<String, dynamic>> options = <Map<String, dynamic>>[
    <String, dynamic>{
      'icon': LucideIcons.coins,
      'title': ' I need Funding / Investment',
      'subtitle': 'Buyer',
    },
    <String, dynamic>{
      'icon': LucideIcons.heartHandshake,
      'title': 'I need Business Partners',
      'subtitle': 'Seller',
    },
    <String, dynamic>{
      'icon': LucideIcons.users,
      'title': 'I need Customers / Supplier',
      'subtitle': 'Supplier',
    },
    <String, dynamic>{
      'icon': LucideIcons.graduationCap,
      'title': 'I need Mentorship',
      'subtitle': 'Partner',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = profileController.myProfile.matchType != null &&
            profileController.myProfile.matchType!.isNotEmpty
        ? profileController.myProfile.matchType!.capitalizeFirst
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: <Widget>[
              _buildHandle(),
              const SizedBox(height: 20),

              // Intro Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: const <Widget>[
                    Icon(
                      LucideIcons.sparkles,
                      size: 45,
                      color: Colors.black,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'What business match do you need?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select an option below. ',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Grid
              Container(
                height: 380,
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: options.map((Map<String, dynamic> option) {
                    final bool isSelected =
                        _selectedOption == option['subtitle'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOption = option['subtitle'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withValues(alpha: 0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(option['icon'],
                                size: 30,
                                color: isSelected ? Colors.black : textDark),
                            const SizedBox(height: 12),
                            Text(
                              option['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.black : textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    isProcessing: isSubmitting,
                    buttonType: ButtonType.elevated,
                    textColor: Colors.white,
                    backgroundColor: Colors.black,
                    onPressed: _selectedOption == null
                        ? () {}
                        : () async {
                            final Map<String, dynamic> updateData =
                                <String, dynamic>{
                              'matchType': _selectedOption!.toLowerCase(),
                            };
                            setState(() {
                              isSubmitting = true;
                            });

                            ApiResponseModel response = await ApiService.put(
                                path:
                                    'users/${profileController.myProfile.uid}',
                                body: updateData);

                            if (response.success) {
                              // Update profile
                              profileController.updateProfile(<String, dynamic>{
                                ...profileController.myProfile.toMap(),
                                ...updateData
                              });

                              // Refresh matches immediately
                              await matchController.fetchMatches();

                              // Close the modal
                              Get.back();

                              // Show success message
                              Get.snackbar(
                                  'Success', 'Profile Updated Successfully');
                            } else {
                              Get.snackbar('Error', 'Profile Update Error');
                            }

                            // Stop the loading state
                            if (mounted) {
                              setState(() {
                                isSubmitting = false;
                              });
                            }
                          },
                    child: const Text(
                      'Find My Match',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
