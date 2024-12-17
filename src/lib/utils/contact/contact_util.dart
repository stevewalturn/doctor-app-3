import 'dart:async';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class ContactUtil {
  static Future<void> launchWhatsApp(String phone, {String text = ''}) async {
    final androidUrl = 'whatsapp://send?phone=$phone&text=$text';
    final iosUrl = 'https://wa.me/$phone?text=${Uri.parse(text)}';

    final webUrl = 'https://api.whatsapp.com/send/?phone=$phone&text=$text';

    try {
      if (Platform.isIOS && (await canLaunchUrl(Uri.parse(iosUrl)))) {
        await launchUrl(Uri.parse(iosUrl));
      } else if (Platform.isAndroid &&
          await canLaunchUrl(Uri.parse(androidUrl))) {
        await launchUrl(Uri.parse(androidUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> launchEmail(String email) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      unawaited(launchUrl(emailLaunchUri));
    }
  }
}
