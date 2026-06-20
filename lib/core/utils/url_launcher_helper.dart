import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class UrlLauncherHelper {
  static Future<void> launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      CustomSnackBar.show(context, message: 'No document URL uploaded.');
      return;
    }
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        CustomSnackBar.show(context, message: 'Could not open preview link.');
      }
    } catch (e) {
      CustomSnackBar.show(context, message: 'Error opening document link.');
    }
  }
}
