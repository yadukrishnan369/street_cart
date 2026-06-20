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
    final String gmailUrl = 'https://mail.google.com/mail/?view=cm&fs=1&to=$email';
    final Uri launchUri = Uri.parse(gmailUrl);
    try {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      final Uri mailtoUri = Uri.parse('mailto:$email');
      try {
        await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
      } catch (err) {
        throw 'Could not launch email client: $err';
      }
    }
  }
}
