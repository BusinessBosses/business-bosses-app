import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/marketplace/widgets/currency.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../services/api_service.dart';
import '../../utils/currency_format.dart';

class PreferredCurrencyScreen extends StatefulWidget {
  const PreferredCurrencyScreen({super.key});

  @override
  State<PreferredCurrencyScreen> createState() =>
      _PreferredCurrencyScreenState();
}

class _PreferredCurrencyScreenState extends State<PreferredCurrencyScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  String? selectedCurrency;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedCurrency = CurrencyFormatter.preferredCurrencyCode();
  }

  void _saveCurrency() async {
    if (selectedCurrency == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final ApiResponseModel response = await ApiService.put(
          path: 'users/${profileController.myProfile.uid}',
          body: <String, dynamic>{'preferredCurrency': selectedCurrency});

      if (response.success == true) {
        // Update local profile
        profileController.updateProfile(<String, dynamic>{
          ...profileController.myProfile.toMap(),
          'preferredCurrency': selectedCurrency
        });
        Get.back();
        Get.snackbar('Success', 'Preferred currency updated');
      } else {
        Get.snackbar('Error', 'Failed to update preferred currency');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating currency');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract unique currency codes and sort them
    final List<String> uniqueCurrencies = currencyValues.values.toSet().toList()
      ..removeWhere((String c) => c.isEmpty)
      ..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferred Currency'),
        actions: <Widget>[
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            onPressed: isLoading ? null : _saveCurrency,
          )
        ],
      ),
      // Selection state lives on the RadioGroup now; the tiles only declare
      // their value (groupValue/onChanged on the tile are deprecated).
      body: RadioGroup<String>(
        groupValue: selectedCurrency,
        onChanged: (String? value) {
          setState(() {
            selectedCurrency = value;
          });
        },
        child: ListView.builder(
          itemCount: uniqueCurrencies.length,
          itemBuilder: (BuildContext context, int index) {
            final String currencyCode = uniqueCurrencies[index];
            return RadioListTile<String>(
              title: Text(currencyCode),
              value: currencyCode,
            );
          },
        ),
      ),
    );
  }
}
