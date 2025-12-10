import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProNotificationSettings extends StatefulWidget {
  const ProNotificationSettings({super.key});

  @override
  State<ProNotificationSettings> createState() =>
      _ProNotificationSettingsState();
}

class _ProNotificationSettingsState extends State<ProNotificationSettings> {
  bool orderConfirmationEmail = true;
  bool orderConfirmationNotification = true;
  bool invoiceReminderEmail = true;
  bool invoiceReminderNotification = true;
  bool reminderEnabled = true;
  int reminderDays = 6;
  bool showOrderTemplate = false;
  bool showInvoiceTemplate = false;
  TextEditingController orderTemplateController = TextEditingController();
  TextEditingController invoiceTemplateController = TextEditingController();

  Widget _buildNotificationSetting(
      String title, String subtitle, bool value, Function(bool) onChanged,
      {String? template,
      bool? sendNotification,
      Function(bool)? onSendNotificationChanged,
      bool isOrderConfirmation = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: proprimaryColor,
            ),
          ),
          if (sendNotification != null && onSendNotificationChanged != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RadioGroup<bool>(
                groupValue: sendNotification,
                onChanged: (bool? value) {
                  if (value != null) {
                    onSendNotificationChanged(value);
                  }
                },
                child: Row(
                  children: <Widget>[
                    const Text('Send me a notification as well?'),
                    const SizedBox(width: 8),
                    Radio<bool>(
                      value: true,
                      activeColor: proprimaryColor,
                    ),
                    const Text('Yes'),
                    Radio<bool>(
                      value: false,
                      activeColor: proprimaryColor,
                    ),
                    const Text('No'),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  if (isOrderConfirmation) {
                    showOrderTemplate = !showOrderTemplate;
                    if (showOrderTemplate) {
                      orderTemplateController.text = template ?? '';
                    }
                  } else {
                    showInvoiceTemplate = !showInvoiceTemplate;
                    if (showInvoiceTemplate) {
                      invoiceTemplateController.text = template ?? '';
                    }
                  }
                });
              },
              child: Text(
                isOrderConfirmation
                    ? (showOrderTemplate ? 'Hide Template' : 'View Template')
                    : (showInvoiceTemplate ? 'Hide Template' : 'View Template'),
                style: const TextStyle(color: proprimaryColor),
              ),
            ),
          ),
          if (isOrderConfirmation && showOrderTemplate)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: orderTemplateController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Edit order confirmation template here',
                ),
              ),
            ),
          if (!isOrderConfirmation && showInvoiceTemplate)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: invoiceTemplateController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Edit invoice reminder template here',
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Automatic Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Send automatic notification messages and reminder to your customers. View and Edit templates',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _buildNotificationSetting(
                    'Order Confirmation',
                    'This message will be sent to your customers immediately after order is placed.',
                    orderConfirmationEmail,
                    (bool value) {
                      setState(() {
                        orderConfirmationEmail = value;
                      });
                    },
                    template:
                        'Your order has been confirmed. Thank you for your purchase!',
                    sendNotification: orderConfirmationNotification,
                    onSendNotificationChanged: (bool value) {
                      setState(() {
                        orderConfirmationNotification = value;
                      });
                    },
                    isOrderConfirmation: true,
                  ),
                  const Divider(height: 1),
                  _buildNotificationSetting(
                    'Invoice Reminder',
                    'This message will be sent if invoice has not been paid',
                    invoiceReminderEmail,
                    (bool value) {
                      setState(() {
                        invoiceReminderEmail = value;
                      });
                    },
                    template:
                        'This is a friendly reminder that your invoice is due. Please make your payment at your earliest convenience.',
                    sendNotification: invoiceReminderNotification,
                    onSendNotificationChanged: (bool value) {
                      setState(() {
                        invoiceReminderNotification = value;
                      });
                    },
                    isOrderConfirmation: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    title: const Text('Reminder'),
                    value: reminderEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        reminderEnabled = value;
                      });
                    },
                    activeThumbColor: proprimaryColor,
                  ),
                  if (reminderEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          const Text('Send reminder before appointment:'),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: reminderDays,
                            items:
                                List<int>.generate(7, (int index) => index + 1)
                                    .map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  reminderDays = newValue;
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text('days'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
