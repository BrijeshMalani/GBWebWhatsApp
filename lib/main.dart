import 'package:flutter/material.dart';
import 'Utils/common.dart';
import 'services/api_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/app_open_ad_manager.dart';
import 'services/app_lifecycle_reactor.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'Utils/app_theme.dart';
import 'Utils/theme_provider.dart' as theme_provider;
import 'package:shared_preferences/shared_preferences.dart';

final appOpenAdManager = AppOpenAdManager();

Future<void> updateNoAdsState() async {
  final prefs = await SharedPreferences.getInstance();
  final noAds = prefs.getBool('no_ads_purchased') ?? false;
  AppOpenAdManager.disableAds = noAds;
  if (noAds) {
    appOpenAdManager.dispose();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check purchase state before anything else
  await updateNoAdsState();

  final data = await ApiService.fetchAppData();
  print('API Response: $data');

  if (data != null) {
    if (data.rewardedFull.isNotEmpty) {
      print('Setting privacy policy: ${data.rewardedFull}');
      Common.privacy_policy = data.rewardedFull;
    }
    if (data.rewardedFull2.isNotEmpty) {
      print('Setting terms and conditions: ${data.rewardedFull2}');
      Common.terms_conditions = data.rewardedFull2;
    }

    if (data.admobId.isNotEmpty) {
      print('Setting banner ad ID: ${data.admobId}');
      Common.bannar_ad_id = data.admobId;
    }
    if (data.admobFull.isNotEmpty) {
      print('Setting interstitial ad ID: ${data.admobFull}');
      Common.interstitial_ad_id = data.admobFull;
    }
    if (data.admobNative.isNotEmpty) {
      print('Setting native ad ID: ${data.admobNative}');
      Common.native_ad_id = data.admobNative;
    }
    if (data.rewardedInt.isNotEmpty) {
      print('Setting native ad ID: ${data.rewardedInt}');
      Common.app_open_ad_id = data.rewardedInt;
    }
    if (data.startAppFull.isNotEmpty) {
      print('Setting native ad ID: ${data.startAppFull}');
      Common.playstore_link = data.startAppFull;
    }
  }

  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize().then((initializationStatus) {
    print('Mobile Ads SDK initialized');
    // Set test device ID
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ['188CBD28D7B3F383A267B0FA91535B3B'],
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
      ),
    );
  });

  // Initialize AppLifecycleReactor
  final appLifecycleReactor =
      AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
  appLifecycleReactor.listenToAppStateChanges();

  // Preload the app open ad
  await appOpenAdManager.loadAd();

  runApp(
    ChangeNotifierProvider(
      create: (_) => theme_provider.ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<theme_provider.ThemeProvider>(context);

    return MaterialApp(
      title: 'GB WhatsApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
