import 'dart:io' show Process;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Robust Cross-Platform Dispatcher for WhatsApp, Email, Phone Calls & Web Links
class CommunicationLauncher {
  /// Cleans and formats phone numbers for WhatsApp URL scheme (e.g. +92 300 1234567 -> 923001234567)
  static String formatPhoneForWhatsApp(String rawPhone) {
    String clean = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    // If starts with 0 (e.g. 03001234567 in Pakistan), replace leading 0 with 92
    if (clean.startsWith('0') && clean.length == 11) {
      clean = '92${clean.substring(1)}';
    }
    return clean;
  }

  /// Dispatches structured message directly to WhatsApp app or WhatsApp Web
  static Future<bool> sendWhatsApp({
    required String phone,
    required String message,
  }) async {
    // 1. Always copy text to clipboard as guaranteed fallback
    await Clipboard.setData(ClipboardData(text: message));

    final cleanPhone = formatPhoneForWhatsApp(phone);
    final encodedMessage = Uri.encodeComponent(message);

    // Primary web/app universal WhatsApp URL
    final urlString = cleanPhone.isNotEmpty
        ? 'https://wa.me/$cleanPhone?text=$encodedMessage'
        : 'https://wa.me/?text=$encodedMessage';

    final uri = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        // Fallback for desktop / web browsers
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        return true;
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp url: $e');
      // On Windows desktop, fallback to cmd start
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
        try {
          await Process.run('cmd', ['/c', 'start', '', urlString]);
          return true;
        } catch (_) {}
      }
      return false;
    }
  }

  /// Dispatches email with subject and pre-formatted body to default email client
  static Future<bool> sendEmail({
    required String email,
    required String subject,
    required String body,
  }) async {
    // 1. Always copy text to clipboard as guaranteed fallback
    await Clipboard.setData(ClipboardData(text: body));

    final cleanEmail = email.trim();
    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body);

    final mailtoUrl = 'mailto:$cleanEmail?subject=$encodedSubject&body=$encodedBody';
    final uri = Uri.parse(mailtoUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        return true;
      }
    } catch (e) {
      debugPrint('Error launching Email client: $e');
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
        try {
          await Process.run('cmd', ['/c', 'start', '', mailtoUrl]);
          return true;
        } catch (_) {}
      }
      return false;
    }
  }

  /// Opens any standard web URL
  static Future<bool> openWebUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
