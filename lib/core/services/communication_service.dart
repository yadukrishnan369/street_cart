import 'package:url_launcher/url_launcher.dart';

class CommunicationService {
  /// open the phone dialer with the number
  Future<void> makeCall(String phoneNumber) async {
    final Uri launchUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch dialer for $phoneNumber';
    }
  }

  /// open the email client with the email
  Future<void> sendEmail(String email) async {
    final Uri launchUri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch email client for $email';
    }
  }
}
