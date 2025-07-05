// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:purchases_flutter/models/customer_info_wrapper.dart';
// import 'package:purchases_flutter/models/offerings_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:wpdualaccount/Monetization/Monetization.dart';
// import 'package:wpdualaccount/utils/colors.dart';
// import 'package:wpdualaccount/utils/fontcommon.dart';

// import '../navigation/tabnavigation.dart';

// class InAppPurchaseTestScreen extends StatefulWidget {
//   const InAppPurchaseTestScreen({super.key});

//   @override
//   State<InAppPurchaseTestScreen> createState() => _InAppPurchaseTestScreenState();
// }

// class _InAppPurchaseTestScreenState extends State<InAppPurchaseTestScreen> {
//   Rx showCloseButton = false.obs;
//   ProductDetails? product;
//   StreamSubscription<List<PurchaseDetails>>? _subscription;
//   final bool _isLoading = false;
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   bool _isPremium = false;
//   Offerings? _offerings;

//   @override
//   void initState() {
//     super.initState();
//     // getSubscription();
//     showCloseButtonFun();
//     // _initializePurchaseListener();
//     // _checkExistingPurchase();
//     // _checkPendingTransactions();
//     checkExistingPurchase();
//     fetchOfferings();
//   }
//   Future<void> checkExistingPurchase() async {

//     try {
//       final customerInfo = await Purchases.getCustomerInfo();
//       // final entitlement = customerInfo.entitlements.all["weeklyplan"];
//       final entitlement = customerInfo.entitlements.all["autoweekly"];

//       print("Entitlement--- $entitlement");

//       print("Activate==== $customerInfo");
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_premium', true);
//       AdMonetization.inAppPurchase = true;
//       setState(() {
//         _isPremium = true;
//       });
//     } catch (e) {
//       print("Error checking premium status: $e");
//     }

//   }

//   Future<void> fetchOfferings() async {
//     try {
//       Offerings offerings = await Purchases.getOfferings();
//       log("Offering---- ${offerings}");

//       setState(() {
//         _offerings = offerings;
//       });
//     } catch (e) {
//       print("Error fetching offerings: $e");
//     }
//   }
//   // Future<void> restorePurchase() async {
//   //   try {
//   //     CustomerInfo customerInfo = await Purchases.restorePurchases();
//   //
//   //     if (customerInfo.entitlements.active.isNotEmpty) {
//   //       final prefs = await SharedPreferences.getInstance();
//   //       await prefs.setBool('is_premium', true);
//   //       AdMonetization.inAppPurchase = true;
//   //       setState(() {
//   //         _isPremium = true;
//   //       });
//   //
//   //       Get.snackbar('Restored', 'Your purchase has been restored.',
//   //           snackPosition: SnackPosition.BOTTOM);
//   //     } else {
//   //       Get.snackbar('Info', 'No previous purchases found.',
//   //           snackPosition: SnackPosition.BOTTOM);
//   //     }
//   //   } catch (e) {
//   //     Get.snackbar('Error', 'Restore failed: $e',
//   //         snackPosition: SnackPosition.BOTTOM);
//   //   }
//   // }

//   Future<void> restorePurchase() async {
//     try {
//       CustomerInfo customerInfo = await Purchases.restorePurchases();

//       // Check for a specific entitlement (e.g., subscription)
//       bool hasSubscription = customerInfo.entitlements.all["autoweekly"]?.isActive == true;

//       if (hasSubscription) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('is_premium', true);
//         AdMonetization.inAppPurchase = true;

//         setState(() {
//           _isPremium = true;
//         });
//         Get.off(()=> const TabNavigationManager(initialIndex:0));

//         Get.snackbar('Restored', 'Your subscription has been restored.',
//             snackPosition: SnackPosition.BOTTOM);
//       } else {
//         Get.snackbar('Info', 'No active subscription found to restore.',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Restore failed: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   showCloseButtonFun() {
//     Timer(const Duration(seconds: 3), () {
//       showCloseButton.value = true;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
//   Future<void> purchase() async {
//     try {
//       if (_offerings != null && _offerings!.current != null) {
//         final package = _offerings!.current!.availablePackages.first;
//         print("Package---- $package");
//         print("availablePackages---- ${_offerings!.current!.availablePackages}");

//         CustomerInfo customerInfo = await Purchases.purchasePackage(package);

//         if (customerInfo.entitlements.active.isNotEmpty) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setBool('is_premium', true);
//           setState(() {
//             _isPremium = true;
//           });
//           AdMonetization.inAppPurchase = true;
//           Get.off(()=> const TabNavigationManager(initialIndex:0));

//           Get.snackbar('Success', 'Thank you for your purchase!',
//               snackPosition: SnackPosition.BOTTOM);
//         }
//       }
//     } on PurchasesErrorCode catch (e) {
//       if (e == PurchasesErrorCode.purchaseCancelledError) {
//         Get.snackbar('Cancelled', 'Purchase was cancelled.',
//             snackPosition: SnackPosition.BOTTOM);
//       } else {
//         Get.snackbar('Error', 'Purchase failed: $e',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     }
//   }
//   // Future<void> purchase() async {
//   //   String packageId = "com.dualaccount.multipleemail.weekly_auto";
//   //
//   //   try {
//   //     if (_offerings != null && _offerings!.current != null) {
//   //       print("Available packages:");
//   //       _offerings!.current!.availablePackages.forEach((p) {
//   //         print("Package identifier: ${p.identifier}, Store Product ID: ${p.storeProduct.identifier}");
//   //       });
//   //
//   //       final package = _offerings!.current!.availablePackages.firstWhere(
//   //             (p) => p.storeProduct.identifier == packageId,
//   //         orElse: () => throw Exception('Package $packageId not found'),
//   //       );
//   //
//   //       print("Selected package: $package");
//   //
//   //       CustomerInfo customerInfo = await Purchases.purchasePackage(package);
//   //
//   //       if (customerInfo.entitlements.active['autoweekly']?.isActive == true) {
//   //         // Your success logic here
//   //       } else {
//   //         // Handle entitlement not active
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print("Error: $e");
//   //     // Your error handling logic here
//   //   }
//   //
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//           // color:AppColor.splashGreen,
//           child: Stack(
//             children: [
//               Image.asset('assets/images/inappback.png',fit:BoxFit.none,height:Get.height,
//                 width: Get.width,),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 70),
//                   Obx(() => Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(width: 12),

//                       showCloseButton.value
//                           ? InkWell(
//                         onTap: () {
//                           if(Get.arguments == 0){
//                             Get.off(()=> const TabNavigationManager(initialIndex:0));
//                           }else{
//                             Get.off(()=> const TabNavigationManager(initialIndex:1));
//                           }
//                         },
//                         child: Icon(Icons.clear, color: Colors.black, size: 24),
//                       )
//                           : Container(width: 30),
//                       SizedBox(width: Get.width / 4),
//                       Image.asset('assets/images/crownn.png', height: 130, width: 130),
//                     ],
//                   )),
//                   Expanded(
//                     child: ListView(
//                       padding: EdgeInsets.zero,
//                       children: [
//                         SizedBox(height: 5),
//                         Align(
//                             alignment: Alignment.center,
//                             child: Text('START LIKE A PRO',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontFamily: FontColor.outFitBold,
//                                     fontSize: 22))),
//                         SizedBox(height: 4),
//                         Align(
//                             alignment: Alignment.center,
//                             child: Text('Unlock Premium Access for All Features',
//                                 style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontFamily: FontColor.outFitRegular,
//                                     fontSize: 16))),

//                         Image.asset('assets/images/inappimage.png',height:Get.height/2.5,),

//                         // Replaced Spacer() with SizedBox
//                         SizedBox(height: 10),

//                         Align(
//                             alignment: Alignment.center,
//                             child: Text(AdMonetization.subscriptionTrialText,
//                                 style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontFamily: FontColor.outFitRegular,
//                                     fontSize: 16))),
//                         SizedBox(height: 20),

//                         InkWell(
//                           onTap: purchase,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 15),
//                             height: 50,
//                             width: Get.width,
//                             decoration: BoxDecoration(
//                               color: _isLoading
//                                   ? Colors.grey
//                                   : AppColor.blueWpColor,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                                 child: _isLoading
//                                     ? CircularProgressIndicator(
//                                         color: Colors.white)
//                                     : Text(AdMonetization.subscriptionButtonText,
//                                         style: TextStyle(
//                                             color: AppColor.whiteColor,
//                                             fontFamily: FontColor.outFitBold,
//                                             fontSize: 20))),
//                           ),
//                         ),
//                         SizedBox(height: 2),
//                         Center(
//                           child: TextButton(
//                             onPressed: restorePurchase,
//                             child: Text(
//                               'Restore Purchases',
//                               style: TextStyle(
//                                 color: AppColor.blueWpColor,
//                                 fontFamily: FontColor.outFitMedium,fontSize:16
//                               ),
//                             ),
//                           ),
//                         ),
//                         // SizedBox(height: 20),
//                         // Align(
//                         //     alignment: Alignment.center,
//                         //     child: Text('Subscription will auto-renew. Cancel anytime',
//                         //         style: TextStyle(
//                         //             color: Colors.grey.shade600,
//                         //             fontFamily: FontColor.outFitRegular,
//                         //             fontSize: 16))),
//                         // SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment:MainAxisAlignment.center,
//                           children: [
//                             Text('By Continue.you agree to our ',style:TextStyle(fontFamily:FontColor.outFitRegular,color:Colors.grey.shade700),),
//                             InkWell(
//                                 onTap:()async{
//                                   if (!await launchUrl(Uri.parse('https://wtdualaccounts.blogspot.com/2025/04/terms-conditions.html'))) {
//                                   }
//                                 },
//                                 child: Text('Terms of Use ',style:TextStyle(fontFamily:FontColor.outFitRegular,fontSize:16))),
//                             Text(' & ',style:TextStyle(fontFamily:FontColor.outFitRegular)),

//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment:MainAxisAlignment.center,
//                           children: [
//                             InkWell(
//                                 onTap:()async{
//                                   if (!await launchUrl(Uri.parse('https://wtdualaccounts.blogspot.com/2025/04/wtdualaccount2025.html'))) {
//                                   }
//                                  },
//                                 child: Text('Privacy Policy ',style:TextStyle(fontFamily:FontColor.outFitMedium,fontSize:16))),
//                             Text('Subscription auto renew, ',style:TextStyle(fontFamily:FontColor.outFitRegular,color:Colors.grey.shade700)),
//                             Text('cancel anytime',style:TextStyle(fontFamily:FontColor.outFitRegular,color:Colors.grey.shade700)),

//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               )

//             ],
//           ),
//         )



//     );
//   }
// }
