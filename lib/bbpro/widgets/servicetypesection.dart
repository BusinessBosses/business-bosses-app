import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicetypeSectionWidget extends StatefulWidget {
  final bool? isOnline;
  final Service service;
  const ServicetypeSectionWidget(
      {Key? key, this.isOnline, required this.service})
      : super(key: key);

  @override
  State<ServicetypeSectionWidget> createState() =>
      _ServicetypeSectionWidgetState();
}

class _ServicetypeSectionWidgetState extends State<ServicetypeSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.isOnline == true ? 'Online' : 'In-Person',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                // Center(
                //   child: Image.asset(
                //     'assets/google_meet_logo.png', // Replace with your Google Meet logo asset
                //     height: 50,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // const Center(
                //   child: Text(
                //     'Google Meet',
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 5),
                // const Center(
                //   child: Text(
                //     'Web conference',
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                Center(
                    child: widget.isOnline == true
                        ? InkWell(
                            onTap: () => launchUrl(Uri.parse(widget.service
                                .url!)), // Replace with your actual profile link
                            child: Text(
                              widget.service.url ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        : Text(
                            widget.service.url ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
