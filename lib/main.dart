import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:yourappname/firebase_options.dart';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/pages/contentshowdetails.dart';
import 'package:yourappname/pages/contentvideodetails.dart';
import 'package:yourappname/pages/splash.dart';
import 'package:yourappname/provider/avatarprovider.dart';
import 'package:yourappname/provider/bottombarprovider.dart';
import 'package:yourappname/provider/connectivityprovider.dart';
import 'package:yourappname/provider/myspaceprovider.dart';
import 'package:yourappname/provider/mysubscribedplanprovider.dart';
import 'package:yourappname/provider/sectionviewallprovider.dart';
import 'package:yourappname/provider/subhistoryprovider.dart';
import 'package:yourappname/provider/videodownloadprovider.dart';
import 'package:yourappname/provider/episodeprovider.dart';
import 'package:yourappname/provider/findprovider.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/homeprovider.dart';
import 'package:yourappname/provider/paymentprovider.dart';
import 'package:yourappname/provider/playerprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/provider/purchaselistprovider.dart';
import 'package:yourappname/provider/rentstoreprovider.dart';
import 'package:yourappname/provider/searchprovider.dart';
import 'package:yourappname/provider/sectionbytypeprovider.dart';
import 'package:yourappname/provider/sectiondataprovider.dart';
import 'package:yourappname/provider/showdetailsprovider.dart';
import 'package:yourappname/provider/subscriptionprovider.dart';
import 'package:yourappname/provider/videobyidprovider.dart';
import 'package:yourappname/provider/videodetailsprovider.dart';
import 'package:yourappname/provider/viewallprovider.dart';
import 'package:yourappname/provider/watchlistprovider.dart';
import 'package:yourappname/pushservice/pushnotificationservice.dart';
import 'package:yourappname/routes/routes_config.dart';
import 'package:yourappname/routes/routes_constant.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final RemoteNotification? notification = message.notification;
  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null) {
    printLog("notification title =====> ${notification.title}");
    printLog("notification body ======> ${notification.body}");
    printLog("notification message ===> ${message.data}");
    Map<String, dynamic>? notificationData = message.data;
    printLog("notificationData =======> $notificationData");
    String? notifyType = notificationData["type"];
    String? deviceToken = notificationData["deviceToken"];
    String? deviceType = notificationData["deviceType"];
    printLog("notifyType =======> $notifyType");
    printLog("deviceToken ======> $deviceToken");
    printLog("deviceType =======> $deviceType");
    if (notifyType == "logout") {
      // Firebase Signout
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await Utils.setUserId(null);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  if (!kIsWeb) {
    await MobileAds.instance.initialize();

    /* Initialize Hive Start */
    final appDocumentDir = await getApplicationDocumentsDirectory();
    printLog("appDocumentDir Path ==> ${appDocumentDir.path}");
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(DownloadItemAdapter());
    Hive.registerAdapter(SessionItemAdapter());
    Hive.registerAdapter(EpisodeItemAdapter());
    /* Initialize Hive End */
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /* Push Notification Set-up */
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  /* Push Notification Set-up */

  await Locales.init([
    'pt',
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => BottombarProvider()),
        ChangeNotifierProvider(create: (_) => AvatarProvider()),
        ChangeNotifierProvider(create: (_) => EpisodeProvider()),
        ChangeNotifierProvider(create: (_) => FindProvider()),
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => MySpaceProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PurchaselistProvider()),
        ChangeNotifierProvider(create: (_) => RentStoreProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SectionByTypeProvider()),
        ChangeNotifierProvider(create: (_) => SectionDataProvider()),
        ChangeNotifierProvider(create: (_) => ShowDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SubHistoryProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => MySubscribedPlanProvider()),
        ChangeNotifierProvider(create: (_) => SectionViewAllProvider()),
        ChangeNotifierProvider(create: (_) => ViewAllProvider()),
        ChangeNotifierProvider(create: (_) => VideoByIDProvider()),
        ChangeNotifierProvider(create: (_) => VideoDetailsProvider()),
        ChangeNotifierProvider(create: (_) => VideoDownloadProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  SharedPre sharedPre = SharedPre();
  late ConnectivityProvider connectivityProvider;
  late ProfileProvider profileProvider;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    printLog("initState deeplinkDomain ====> ${Constant.deeplinkDomain}");
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    // if (!kIsWeb) Utils.preventScreenCapture();

    /* Push Notification Set-up */
    PushNotificationService().setupInteractedMessage(context);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    /* Push Notification Set-up */

    if (!mounted) return;
    _getUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await connectivityProvider.initConnectivity(context);
      await _getDeviceInfo();
      if (!kIsWeb) await _fetchIntro();
      await _getData();

      /* Deep Link */
      if (!mounted) return;
      initDeepLinks(context: context);
    });
    super.initState();
  }

  _getUserData() async {
    Constant.userID = await sharedPre.read('userid');
    Constant.userIsKid = await sharedPre.readBool(Constant.profileUserKey);
    printLog('_getData userID ===========> ${Constant.userID}');
    printLog('_getData userIsKid ========> ${Constant.userIsKid}');
    printLog('_getData currentDeviceId ==> ${Constant.currentDeviceId}');

    if (Constant.userIsKid == null) {
      await Utils.setUserMode(false);
    }
  }

  Future _getData() async {
    /* *********** Check For Device START *********** */
    if (connectivityProvider.isOnline && Constant.userID != null) {
      await profileProvider.getDeviceSyncList();
      if (profileProvider.deviceSyncModel.result != null &&
          (profileProvider.deviceSyncModel.result?.length ?? 0) > 0) {
        bool? isDeviceContains =
            profileProvider.deviceSyncModel.result?.any((deviceItem) {
          printLog("_getData deviceList userId ====> ${deviceItem.userId}");
          printLog("_getData deviceList deviceId ==> ${deviceItem.deviceId}");
          return ((deviceItem.deviceId ?? "") == Constant.currentDeviceId);
        });
        printLog("_getData isDeviceContains ====> $isDeviceContains");
        if (isDeviceContains == false) {
          PushNotificationService.onLogoutDelete();
          return;
        }
      }

      if (!mounted) return;
      profileProvider.getProfile(context);
    }
    /* *********** Check For Device END ************* */

    /* Initialize Hive */
    if (!kIsWeb) {
      await Utils.initializeHiveBoxes();
    }
  }

  Future<void> initDeepLinks({required BuildContext context}) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Handle links
      _linkSubscription =
          AppLinks().uriLinkStream.listen((Uri initialLink) async {
        printLog("========================================");
        printLog("initDeepLinks initialLink ====> $initialLink");
        printLog("========================================");

        // String splittedURL = initialLink.split("?")[0];
        // String splittedParams = initialLink.split("?")[1];
        // printLog("splittedURL ======> $splittedURL");
        // printLog("splittedParams ===> $splittedParams");
        final encodedParams = initialLink.query;
        printLog("initDeepLinks encodedParams ==> $encodedParams");
        if (encodedParams.isEmpty) return;

        String decodeParams = utf8.decode(base64Decode(encodedParams));
        printLog("initDeepLinks decodeParams ===> $decodeParams");

        String hostWithScheme = "${initialLink.scheme}://${initialLink.host}";
        printLog("initDeepLinks hostWithScheme => $hostWithScheme");

        String finalURL = "$hostWithScheme?$decodeParams";
        printLog("initDeepLinks finalURL =======> $finalURL");

        /* Get params & open Details */
        final decodedUri = Uri.parse(finalURL);
        final newPage = decodedUri.queryParameters['newpage'];
        final videoId = int.parse(decodedUri.queryParameters['videoid'] ?? "0");
        final typeId = int.parse(decodedUri.queryParameters['typeid'] ?? "0");
        final videoType =
            int.parse(decodedUri.queryParameters['videotype'] ?? "0");
        final subVideoType =
            int.parse(decodedUri.queryParameters['subvideotype'] ?? "0");
        printLog("initDeepLinks newPage ========> $newPage");
        printLog("initDeepLinks videoId ========> $videoId");
        printLog("initDeepLinks typeId =========> $typeId");
        printLog("initDeepLinks videoType ======> $videoType");
        printLog("initDeepLinks subVideoType ===> $subVideoType");

        /* Initialize Hive */
        if (!kIsWeb) {
          await Utils.initializeHiveBoxes();
        }
        if (context.mounted) {
          if (navigatorKey.currentContext != null) {
            final videoDetailsProvider = Provider.of<VideoDetailsProvider>(
                navigatorKey.currentContext!,
                listen: false);
            final showDetailsProvider =
                Provider.of<ShowDetailsProvider>(context, listen: false);

            if (videoType == 5 || videoType == 6 || videoType == 7) {
              if (subVideoType == 1) {
                await videoDetailsProvider.setLoading(true);
                if (!(context.mounted)) return;
                if (kIsWeb || Constant.isTV) {
                  context.pushNamed(
                    RoutesConstant.videoDetailsPage,
                    extra: {
                      'newpage': newPage.toString(),
                      'videoid': videoId.toString(),
                      'subvideotype': subVideoType.toString(),
                      'videotype': videoType.toString(),
                      'typeid': typeId.toString()
                    },
                  );
                } else {
                  await navigatorKey.currentState?.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ContentVideoDetails(
                          videoId,
                          subVideoType,
                          videoType,
                          typeId,
                        );
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                }
              } else if (subVideoType == 2) {
                await showDetailsProvider.setLoading(true);
                if (!(context.mounted)) return;
                if (kIsWeb || Constant.isTV) {
                  context.pushNamed(
                    RoutesConstant.showDetailsPage,
                    extra: {
                      'newpage': newPage.toString(),
                      'videoid': videoId.toString(),
                      'subvideotype': subVideoType.toString(),
                      'videotype': videoType.toString(),
                      'typeid': typeId.toString()
                    },
                  );
                } else {
                  await navigatorKey.currentState?.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ContentShowDetails(
                          videoId,
                          subVideoType,
                          videoType,
                          typeId,
                        );
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                }
              }
            } else {
              if (videoType == 1) {
                await videoDetailsProvider.setLoading(true);
                if (!(context.mounted)) return;
                if (kIsWeb || Constant.isTV) {
                  context.pushNamed(
                    RoutesConstant.videoDetailsPage,
                    extra: {
                      'newpage': newPage.toString(),
                      'videoid': videoId.toString(),
                      'subvideotype': subVideoType.toString(),
                      'videotype': videoType.toString(),
                      'typeid': typeId.toString()
                    },
                  );
                } else {
                  await navigatorKey.currentState?.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ContentVideoDetails(
                          videoId,
                          subVideoType,
                          videoType,
                          typeId,
                        );
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                }
              } else if (videoType == 2) {
                await showDetailsProvider.setLoading(true);
                if (!(context.mounted)) return;
                if (kIsWeb || Constant.isTV) {
                  context.pushNamed(
                    RoutesConstant.showDetailsPage,
                    extra: {
                      'newpage': newPage.toString(),
                      'videoid': videoId.toString(),
                      'subvideotype': subVideoType.toString(),
                      'videotype': videoType.toString(),
                      'typeid': typeId.toString()
                    },
                  );
                } else {
                  await navigatorKey.currentState?.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ContentShowDetails(
                          videoId,
                          subVideoType,
                          videoType,
                          typeId,
                        );
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                }
              }
            }
          }
        }
      });
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    printLog('didChangeAppLifecycleState state =====> ${state.name}');
    switch (state) {
      case AppLifecycleState.resumed:
        if (!mounted) return;
        _getData();
        break;
      case AppLifecycleState.paused:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) {
        if (kIsWeb) {
          return _buildForWeb(locale: locale);
        } else {
          return _buildForOther(locale: locale);
        }
      },
    );
  }

  Widget _buildForWeb({required Locale? locale}) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesConfig().goRouter,
      theme: ThemeData(
        primaryColor: colorPrimary,
        primaryColorDark: colorPrimaryDark,
        primaryColorLight: colorPrimary,
        scaffoldBackgroundColor: appBgColor,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: kIsWeb
              ? {
                  for (final platform in TargetPlatform.values)
                    platform: const NoTransitionsBuilder(),
                }
              : const {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
        ),
      ).copyWith(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: WidgetStateProperty.all(white),
          trackVisibility: WidgetStateProperty.all(true),
          trackColor: WidgetStateProperty.all(white.withValues(alpha: 0.5)),
        ),
      ),
      title: Constant.appName,
      localizationsDelegates: Locales.delegates,
      supportedLocales: Locales.supportedLocales,
      locale: locale,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        return const Locale('pt', 'BR');
      },
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 360, name: MOBILE),
            const Breakpoint(start: 361, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1000, name: DESKTOP),
            const Breakpoint(start: 1001, end: double.infinity, name: '4K'),
          ],
        );
      },
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad
        },
      ),
    );
  }

  Widget _buildForOther({required Locale? locale}) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver], //HERE
      theme: ThemeData(
        primaryColor: colorPrimary,
        primaryColorDark: colorPrimaryDark,
        primaryColorLight: colorPrimary,
        scaffoldBackgroundColor: appBgColor,
      ).copyWith(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: WidgetStateProperty.all(white),
          trackVisibility: WidgetStateProperty.all(true),
          trackColor: WidgetStateProperty.all(white.withValues(alpha: 0.5)),
        ),
      ),
      title: Constant.appName,
      localizationsDelegates: Locales.delegates,
      supportedLocales: Locales.supportedLocales,
      locale: locale,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        return const Locale('pt', 'BR');
      },
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
      home: const Splash(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad
        },
      ),
    );
  }

  Future _fetchIntro() async {
    final generalsetting = Provider.of<GeneralProvider>(context, listen: false);
    if (connectivityProvider.isOnline) {
      await generalsetting.getIntroPages();
    }
  }

  _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      printLog('_getDeviceInfo Running on : ${webBrowserInfo.platform}');
      printLog('_getDeviceInfo userAgent ======>> ${webBrowserInfo.userAgent}');
      Constant.deviceName = webBrowserInfo.platform ?? '';

      /* <<<<<< Web DeviceId START >>>>>> */
      final cookies = html.document.cookie?.split('; ') ?? [];
      final deviceIdCookie = cookies.firstWhere(
        (cookie) => cookie.startsWith('device_id='),
        orElse: () => '',
      );

      printLog('_getDeviceInfo deviceIdCookie =====>> $deviceIdCookie');
      if (deviceIdCookie.isNotEmpty) {
        printLog(
            '_getDeviceInfo deviceIdCookie =====>> ${deviceIdCookie.split('=')[1]}');
        Constant.currentDeviceId = deviceIdCookie.split('=')[1];
      } else {
        final uuid = const Uuid().v4();
        final generatedDeviceId = Utils.sha256ofString(uuid);
        printLog('_getDeviceInfo uuid ===============>> $uuid');
        printLog('_getDeviceInfo generatedDeviceId ==>> $generatedDeviceId');
        html.document.cookie =
            'device_id=$generatedDeviceId; path=/; max-age=31536000'; // 1 year
        Constant.currentDeviceId = generatedDeviceId;
      }
      /* <<<<<< Web DeviceId END >>>>>> */
    } else {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        Constant.isTV =
            androidInfo.systemFeatures.contains('android.software.leanback');
        printLog("_getDeviceInfo isTV ==============> ${Constant.isTV}");
        printLog('_getDeviceInfo Running on : ${androidInfo.product}');
        Constant.deviceName = "${androidInfo.brand} ${androidInfo.product}";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        printLog('_getDeviceInfo Running on : ${iosInfo.utsname.machine}');
        Constant.deviceName = iosInfo.utsname.machine;
      }

      /* <<<<<< DeviceId START >>>>>> */
      try {
        String consistentUdid = await FlutterUdid.consistentUdid;
        String udid = await FlutterUdid.udid;
        printLog("_getDeviceInfo consistentUdid ======> $consistentUdid");
        printLog("_getDeviceInfo udid ================> $udid");
        Constant.currentDeviceId = consistentUdid;
      } on PlatformException catch (e) {
        printLog("_getDeviceInfo PlatformException ===> $e");
      }
      /* <<<<<< DeviceId END >>>>>> */
    }
    printLog(
        "===========================\nDeviceName => ${Constant.deviceName}\nDeviceId => ${Constant.currentDeviceId}\n===========================");
  }
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    return child!;
  }
}
