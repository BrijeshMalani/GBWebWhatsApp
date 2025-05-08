import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Utils/common.dart';
import 'Utils/app_theme.dart';
import 'Utils/theme_provider.dart' as theme_provider;
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import 'WebViewScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<theme_provider.ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeTile(context, themeProvider, isDarkMode),
          Divider(),
          _buildSectionHeader(context, 'About'),
          _buildAboutTile(context),
          Divider(),
          _buildSectionHeader(context, 'Legal'),
          _buildPrivacyPolicyTile(context),
          _buildTermsAndConditionsTile(context),
          Divider(),
          _buildSectionHeader(context, 'Share'),
          _buildShareAppTile(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context,
      theme_provider.ThemeProvider themeProvider, bool isDarkMode) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        'Dark Mode',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) => themeProvider.toggleTheme(),
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        'About GB WhatsApp',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Version 1.0.0',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      onTap: () {
        // Show about dialog
      },
    );
  }

  Widget _buildPrivacyPolicyTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.privacy_tip_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        'Privacy Policy',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: Common.privacy_policy,
              title: 'Privacy Policy',
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsAndConditionsTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.description_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        'Terms and Conditions',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: Common.terms_conditions,
              title: 'Terms and Conditions',
            ),
          ),
        );
      },
    );
  }

  Widget _buildShareAppTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.share_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        'Share App',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Share with friends',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      onTap: () {
        Share.share(
          'Check out GB WhatsApp - A powerful WhatsApp mod with amazing features!\n\nDownload now: ${Common.playstore_link}',
          subject: 'GB WhatsApp - Download Now!',
        );
      },
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SettingsButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
