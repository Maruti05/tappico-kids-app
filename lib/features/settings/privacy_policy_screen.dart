import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/tappico_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String _markdownData = """
# Privacy Policy

We respect your privacy — especially when it comes to children. This app is designed to provide a safe and simple learning experience for kids.

---

## 1. Overview
This application ("we", "our", or "us") provides a kids learning experience focused on alphabets (ABCD) and numbers (123).

We are committed to protecting the privacy of children and ensuring a safe environment for learning.

---

## 2. Information We Collect

We follow strict data minimization principles.

### We DO NOT collect:
- Name, email address, or phone number  
- Personal identifiers  
- Contacts, photos, or files  
- Precise location data  

### We MAY collect limited non-personal data:
- Device type and OS version  
- App usage data (e.g., screens visited, interactions)  
- Crash reports and diagnostics  

This data is anonymous and used only to improve app performance and user experience.

---

## 3. How We Use Data

We use limited collected data only to:
- Improve app performance and stability  
- Fix bugs and crashes  
- Enhance user experience  

We do NOT use data for:
- Advertising personalization  
- Profiling  
- Tracking users across apps  

---

## 4. Advertising

We may display ads using Google AdMob.

To ensure child safety:
- We only use non-personalized ads  
- We do NOT use behavioral targeting  
- Ads are filtered for child-appropriate content  

AdMob may collect limited information such as:
- Device information  
- Advertising ID  
- IP address (for general location)  

This data is handled according to Google's privacy policy.

### Parental Controls:
Parents can:
- Disable ad personalization in device settings  
- Reset the advertising ID  
- Restrict internet access if desired  

---

## 5. Data Sharing

We do NOT sell, rent, or trade any data.

We may share limited data only with:
- Service providers (e.g., analytics, crash reporting)  
- Legal authorities if required by law  

All third parties are required to protect data securely.

---

## 6. Data Storage & Security

We implement industry-standard security measures:
- Encrypted data transmission (HTTPS)  
- Secure storage practices  
- Limited access to data  

We retain data only as long as necessary to maintain app functionality.

---

## 7. Children's Privacy

This app is designed for children.

We take extra precautions:
- No account registration required  
- No personal data collection from children  
- No user input fields for personal information  

If you believe a child has shared personal information, please contact us immediately and we will delete it.

---

## 8. Tracking & Technologies

We do not use cookies in the traditional web sense.

We may use:
- Local storage for saving app settings  
- Basic analytics for performance improvement  

No tracking is used for advertising personalization.

---

## 9. Your Rights

Parents or guardians may:
- Request deletion of any collected data  
- Contact us for privacy-related concerns  

We will respond within a reasonable timeframe.

---

## 10. Changes to This Policy

We may update this Privacy Policy from time to time.

Changes will be reflected in this document. Continued use of the app means you accept the updated policy.

---

## 11. Contact Us

For any questions or concerns:

- Email: privacy@vedicalabs.in  
- Address: Karnataka, India  

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Privacy Policy',
        showSettings: false,
      ),
      body: const SafeArea(
        top: false,
        bottom: false,
        child: _PrivacyContent(),
      ),
    );
  }
}

class _PrivacyContent extends StatelessWidget {
  const _PrivacyContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Markdown(
      data: PrivacyPolicyScreen._markdownData,
      selectable: true,
      padding: const EdgeInsets.all(24),
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        h2: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          height: 2.0,
        ),
        h3: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        p: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: AppColors.textMid,
        ),
        listBullet: const TextStyle(
          fontSize: 15,
          color: AppColors.textMid,
        ),
      ),
    );
  }
}