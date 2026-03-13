import 'package:handsplay/model/playermodel.dart';
import 'package:handsplay/pages/activetv.dart';
import 'package:handsplay/pages/find.dart';
import 'package:handsplay/subscription/allpayment.dart';
import 'package:handsplay/subscription/contactus.dart';
import 'package:handsplay/subscription/mypurchaselist.dart';
import 'package:handsplay/pages/myspace.dart';
import 'package:handsplay/pages/mywatchlist.dart';
import 'package:handsplay/pages/profile.dart';
import 'package:handsplay/pages/profileavatar.dart';
import 'package:handsplay/pages/profileedit.dart';
import 'package:handsplay/pages/sectionviewall.dart';
import 'package:handsplay/pages/settings.dart';
import 'package:handsplay/pages/viewall.dart';
import 'package:handsplay/players/player_vimeo.dart';
import 'package:handsplay/routes/routes_constant.dart';
import 'package:handsplay/subscription/mysubscribedplan.dart';
import 'package:handsplay/subscription/subscription.dart';
import 'package:handsplay/subscription/subscriptionhistory.dart';
import 'package:handsplay/webpages/webmyspace.dart';
import 'package:handsplay/webpages/webprofile.dart';
import 'package:handsplay/webpages/webprofileavatar.dart';
import 'package:handsplay/webpages/webprofileedit.dart';
import 'package:handsplay/webpages/websearch.dart';
import 'package:handsplay/webpages/websectionviewall.dart';
import 'package:handsplay/webpages/websettings.dart';
import 'package:handsplay/webpages/webviewall.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:handsplay/main.dart';
import 'package:handsplay/pages/aboutprivacyterms.dart';
import 'package:handsplay/pages/contentvideodetails.dart';
import 'package:handsplay/pages/rentstore.dart';
import 'package:handsplay/pages/contentshowdetails.dart';
import 'package:handsplay/pages/splash.dart';
import 'package:handsplay/pages/contentbyid.dart';
import 'package:handsplay/players/player_video.dart';
import 'package:handsplay/players/player_youtube.dart';
import 'package:handsplay/webpages/weberrorpage.dart';
import 'package:handsplay/webpages/webaboutprivacyterms.dart';
import 'package:handsplay/webpages/webhome.dart';
import 'package:handsplay/webpages/webcontentvideodetails.dart';
import 'package:handsplay/webpages/webrentstore.dart';
import 'package:handsplay/webpages/webcontentshowdetails.dart';
import 'package:handsplay/webpages/webcontentbyid.dart';
import 'package:handsplay/webpages/webmywatchlist.dart';
import 'package:handsplay/utils/constant.dart';
import 'package:handsplay/utils/utils.dart';

class RoutesConfig {
  GoRouter goRouter = GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    observers: [routeObserver], //HERE
    routes: [
      /* Initial route by Platform */
      GoRoute(
        name: RoutesConstant.homePage,
        path: '/',
        builder: (context, state) {
          if (kIsWeb || Constant.isTV) {
            return const WebHome(
              newPage: RoutesConstant.homePage,
              oldPage: RoutesConstant.homePage,
              reqText: '',
            );
          }
          return const Splash();
        },
      ),

      /* Search */
      GoRoute(
        name: RoutesConstant.searchPage,
        path: '/${RoutesConstant.searchPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;

            if (kIsWeb || Constant.isTV) {
              return WebSearch(
                newPage: RoutesConstant.searchPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return Find(viewFrom: newPage);
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Rent */
      GoRoute(
        name: RoutesConstant.storePage,
        path: '/${RoutesConstant.storePage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null) {
            newPage = state.extra as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebRentStore(
                newPage: RoutesConstant.storePage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const RentStore();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Watchlist */
      GoRoute(
        name: RoutesConstant.myWatchlistPage,
        path: '/${RoutesConstant.myWatchlistPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null) {
            newPage = state.extra as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebMyWatchlist(
                newPage: RoutesConstant.myWatchlistPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const MyWatchlist();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Video Details */
      GoRoute(
        name: RoutesConstant.videoDetailsPage,
        path: '/${RoutesConstant.videoDetailsPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? videoId, videoType, subVideoType, typeId;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            videoId = extraData['videoid'] as String;
            videoType = extraData['videotype'] as String;
            subVideoType = extraData['subvideotype'] as String;
            typeId = extraData['typeid'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebContentVideoDetails(
                int.parse(videoId),
                int.parse(subVideoType),
                int.parse(videoType),
                int.parse(typeId),
                newPage: RoutesConstant.videoDetailsPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ContentVideoDetails(
              int.parse(videoId),
              int.parse(subVideoType),
              int.parse(videoType),
              int.parse(typeId),
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Show Details */
      GoRoute(
        name: RoutesConstant.showDetailsPage,
        path: '/${RoutesConstant.showDetailsPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? videoId, videoType, subVideoType, typeId;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            videoId = extraData['videoid'] as String;
            videoType = extraData['videotype'] as String;
            subVideoType = extraData['subvideotype'] as String;
            typeId = extraData['typeid'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebContentShowDetails(
                int.parse(videoId),
                int.parse(subVideoType),
                int.parse(videoType),
                int.parse(typeId),
                newPage: RoutesConstant.showDetailsPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ContentShowDetails(
              int.parse(videoId),
              int.parse(subVideoType),
              int.parse(videoType),
              int.parse(typeId),
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Players */
      GoRoute(
        name: RoutesConstant.playerPage,
        path: '/${RoutesConstant.playerPage}',
        builder: (context, state) {
          String newPage = "";
          PlayerModel playerModel;
          if (state.extra != null && state.extra is PlayerModel) {
            playerModel = state.extra as PlayerModel;
            printLog("newPage =====> $newPage");
            if (playerModel.uploadType == "youtube") {
              return PlayerYoutube(playerModel: playerModel);
            } else if (playerModel.uploadType == "external") {
              if ((playerModel.videoUrl ?? "").contains('youtube')) {
                return PlayerYoutube(playerModel: playerModel);
              } else if ((playerModel.videoUrl ?? "").contains("vimeo")) {
                return PlayerVimeo(playerModel: playerModel);
              } else {
                return PlayerVideo(playerModel: playerModel);
              }
            } else if (playerModel.uploadType == "live_stream_url") {
              if ((playerModel.videoUrl ?? "").contains('youtube')) {
                return PlayerYoutube(playerModel: playerModel);
              } else if ((playerModel.videoUrl ?? "").contains("vimeo")) {
                return PlayerVimeo(playerModel: playerModel);
              } else {
                return PlayerVideo(playerModel: playerModel);
              }
            } else if (playerModel.uploadType == "vimeo") {
              return PlayerVimeo(playerModel: playerModel);
            } else {
              return PlayerVideo(playerModel: playerModel);
            }
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Section ViewAll */
      GoRoute(
        name: RoutesConstant.sectionDetailsPage,
        path: '/${RoutesConstant.sectionDetailsPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? itemID, videoType, appBarTitle, screenLayout;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemID = extraData['itemid'] as String;
            videoType = extraData['videotype'] as String;
            screenLayout = extraData['screenlayout'] as String;
            appBarTitle = extraData['title'] as String;

            printLog("newPage =====> $newPage");
            printLog("videoType ===> $videoType");
            if (kIsWeb || Constant.isTV) {
              return WebSectionViewAll(
                sectionId: int.parse(itemID),
                videoType: int.parse(videoType),
                appBarTitle: appBarTitle,
                screenLayout: screenLayout,
                newPage: RoutesConstant.sectionDetailsPage,
                oldPage: newPage,
                reqText: itemID,
              );
            }
            return SectionViewAll(
              appBarTitle: appBarTitle,
              screenLayout: screenLayout,
              sectionId: int.parse(itemID),
              videoType: int.parse(videoType),
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Video By Category */
      GoRoute(
        name: RoutesConstant.videoByCatPage,
        path: '/${RoutesConstant.videoByCatPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? itemID, appBarTitle, layoutType;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemID = extraData['itemid'] as String;
            appBarTitle = extraData['title'] as String;
            layoutType = extraData['layouttype'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebVideosByID(
                int.parse(itemID),
                appBarTitle,
                layoutType,
                newPage: RoutesConstant.videoByCatPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ContentByID(
              int.parse(itemID),
              appBarTitle,
              layoutType,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Video By Language */
      GoRoute(
        name: RoutesConstant.videoByLanguagePage,
        path: '/${RoutesConstant.videoByLanguagePage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? itemID, appBarTitle, layoutType;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemID = extraData['itemid'] as String;
            appBarTitle = extraData['title'] as String;
            layoutType = extraData['layouttype'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebVideosByID(
                int.parse(itemID),
                appBarTitle,
                layoutType,
                newPage: RoutesConstant.videoByLanguagePage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ContentByID(
              int.parse(itemID),
              appBarTitle,
              layoutType,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Video By Channel */
      GoRoute(
        name: RoutesConstant.videoByChannelPage,
        path: '/${RoutesConstant.videoByChannelPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? itemID, appBarTitle, layoutType;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemID = extraData['itemid'] as String;
            appBarTitle = extraData['title'] as String;
            layoutType = extraData['layouttype'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebVideosByID(
                int.parse(itemID),
                appBarTitle,
                layoutType,
                newPage: RoutesConstant.videoByChannelPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ContentByID(
              int.parse(itemID),
              appBarTitle,
              layoutType,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Video By Cast */
      GoRoute(
        name: RoutesConstant.videoByCastPage,
        path: '/${RoutesConstant.videoByCastPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? itemID, appBarTitle, layoutType;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemID = extraData['itemid'] as String;
            appBarTitle = extraData['title'] as String;
            layoutType = extraData['layouttype'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebVideosByID(
                int.parse(itemID),
                appBarTitle,
                layoutType,
                newPage: RoutesConstant.videoByCastPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ContentByID(
              int.parse(itemID),
              appBarTitle,
              layoutType,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Related Content (ViewAll) */
      GoRoute(
        name: RoutesConstant.relatedContentPage,
        path: '/${RoutesConstant.relatedContentPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? itemID, appBarTitle, videoType, subVideoType, typeId;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemID = extraData['itemid'] as String;
            appBarTitle = extraData['title'] as String;
            subVideoType = extraData['subvideotype'] as String;
            videoType = extraData['videotype'] as String;
            typeId = extraData['typeid'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebViewAll(
                appBarTitle: appBarTitle,
                videoId: int.parse(itemID),
                subVideoType: int.parse(subVideoType),
                videoType: int.parse(videoType),
                typeId: int.parse(typeId),
                newPage: RoutesConstant.relatedContentPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ViewAll(
              appBarTitle: appBarTitle,
              videoId: int.parse(itemID),
              subVideoType: int.parse(subVideoType),
              videoType: int.parse(videoType),
              typeId: int.parse(typeId),
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Continue Watching (ViewAll) */
      GoRoute(
        name: RoutesConstant.continueWatchPage,
        path: '/${RoutesConstant.continueWatchPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? appBarTitle;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            appBarTitle = extraData['title'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebViewAll(
                appBarTitle: appBarTitle,
                videoId: 0,
                subVideoType: 0,
                videoType: 0,
                typeId: 0,
                newPage: RoutesConstant.continueWatchPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return ViewAll(
              appBarTitle: appBarTitle,
              videoId: 0,
              subVideoType: 0,
              videoType: 0,
              typeId: 0,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* About Us, Privacy Policy & etc. */
      GoRoute(
        name: RoutesConstant.aboutPrivacyTermsPage,
        path: '/${RoutesConstant.aboutPrivacyTermsPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          String? appBarTitle, url;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            appBarTitle = extraData['title'] as String;
            url = extraData['url'] as String;

            printLog("newPage =====> $newPage");
            if (kIsWeb || Constant.isTV) {
              return WebAboutPrivacyTerms(
                newPage: RoutesConstant.aboutPrivacyTermsPage,
                oldPage: newPage,
                reqText: '',
                appBarTitle: appBarTitle,
                loadURL: url,
              );
            }
            return AboutPrivacyTerms(
              appBarTitle: appBarTitle,
              loadURL: url,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Login */
      // GoRoute(
      //   name: RoutesConstant.loginSocialPage,
      //   path: '/${RoutesConstant.loginSocialPage}',
      //   builder: (context, state) {
      //     String newPage = "";
      //     if (state.extra != null && state.extra is String) {
      //       newPage = state.extra as String;
      //       printLog("newPage =====> $newPage");
      //       if (kIsWeb || Constant.isTV) {
      //         return WebLoginSocial(
      //           newPage: RoutesConstant.loginSocialPage,
      //           oldPage: newPage,
      //           reqText: '',
      //         );
      //       }
      //       return const LoginSocial();
      //     } else {
      //       return WebErrorPage(state.error!);
      //     }
      //   },
      // ),

      /* Login OTP */
      // GoRoute(
      //   name: RoutesConstant.loginOTPPage,
      //   path: '/${RoutesConstant.loginOTPPage}',
      //   builder: (context, state) {
      //     String newPage = "", mobileNumber = "";
      //     Map<String, dynamic> extraData = {};
      //     if (state.extra != null && state.extra is Map<String, dynamic>) {
      //       extraData = state.extra as Map<String, dynamic>;
      //       newPage = extraData['newpage'] as String;
      //       mobileNumber = extraData['mobile'] as String;
      //       printLog("newPage =======> $newPage");
      //       printLog("mobileNumber ==> $mobileNumber");
      //       if (kIsWeb || Constant.isTV) {
      //         return WebOTPVerify(
      //           mobileNumber,
      //           newPage: RoutesConstant.loginOTPPage,
      //           oldPage: newPage,
      //           reqText: '',
      //         );
      //       }
      //       return OTPVerify(mobileNumber);
      //     } else {
      //       return WebErrorPage(state.error!);
      //     }
      //   },
      // ),

      /* Avatar */
      GoRoute(
        name: RoutesConstant.avatarPage,
        path: '/${RoutesConstant.avatarPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            if (kIsWeb || Constant.isTV) {
              return WebProfileAvatar(
                newPage: RoutesConstant.avatarPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const ProfileAvatar();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Profile */
      GoRoute(
        name: RoutesConstant.myProfilePage,
        path: '/${RoutesConstant.myProfilePage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            if (kIsWeb || Constant.isTV) {
              return WebProfile(
                newPage: RoutesConstant.myProfilePage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const Profile();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* My Sapce */
      GoRoute(
        name: RoutesConstant.mySpacePage,
        path: '/${RoutesConstant.mySpacePage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            if (kIsWeb || Constant.isTV) {
              return WebMySpace(
                newPage: RoutesConstant.mySpacePage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const MySpace();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Settings */
      GoRoute(
        name: RoutesConstant.settingsPage,
        path: '/${RoutesConstant.settingsPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            if (kIsWeb || Constant.isTV) {
              return WebSettings(
                newPage: RoutesConstant.settingsPage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const Settings();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Edit Profile */
      GoRoute(
        name: RoutesConstant.editProfilePage,
        path: '/${RoutesConstant.editProfilePage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            if (kIsWeb || Constant.isTV) {
              return WebProfileEdit(
                newPage: RoutesConstant.editProfilePage,
                oldPage: newPage,
                reqText: '',
              );
            }
            return const ProfileEdit();
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Active TV */
      GoRoute(
        name: RoutesConstant.activeTVPage,
        path: '/${RoutesConstant.activeTVPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");
            return ActiveTV(
              newPage: RoutesConstant.activeTVPage,
              oldPage: newPage,
              reqText: '',
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Subscription */
      GoRoute(
        name: RoutesConstant.subscriptionPage,
        path: '/${RoutesConstant.subscriptionPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            return Subscription(
              newPage: RoutesConstant.subscriptionPage,
              oldPage: newPage,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* My Subscription */
      GoRoute(
        name: RoutesConstant.mySubscribePlanPage,
        path: '/${RoutesConstant.mySubscribePlanPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            return MySubscribedPlan(
              newPage: RoutesConstant.mySubscribePlanPage,
              oldPage: newPage,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Contact Us */
      GoRoute(
        name: RoutesConstant.contactUsPage,
        path: '/${RoutesConstant.contactUsPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");

            return ContactUs(
              newPage: RoutesConstant.contactUsPage,
              oldPage: newPage,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* All Payments Page */
      GoRoute(
        name: RoutesConstant.paymentPage,
        path: '/${RoutesConstant.paymentPage}',
        builder: (context, state) {
          String newPage = "";
          Map<String, dynamic> extraData = {};
          final String? payType,
              producerId,
              itemId,
              price,
              itemTitle,
              typeId,
              videoType,
              subVideoType,
              productPackage,
              currency;
          if (state.extra != null && state.extra is Map<String, dynamic>) {
            extraData = state.extra as Map<String, dynamic>;
            newPage = extraData['newpage'] as String;
            itemId = extraData['itemid'] as String;
            producerId = extraData['producerid'] as String;
            payType = extraData['paytype'] as String;
            price = extraData['price'] as String;
            itemTitle = extraData['title'] as String;
            typeId = extraData['typeid'] as String;
            videoType = extraData['videotype'] as String;
            subVideoType = extraData['subvideotype'] as String;
            productPackage = extraData['productpackage'] as String;
            currency = extraData['currency'] as String;

            printLog("newPage =====> $newPage");
            return AllPayment(
              newPage: RoutesConstant.paymentPage,
              oldPage: newPage,
              reqText: '',
              payType: payType,
              producerId: producerId,
              itemId: itemId,
              price: price,
              itemTitle: itemTitle,
              typeId: typeId,
              videoType: videoType,
              subVideoType: subVideoType,
              productPackage: productPackage,
              currency: currency,
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Subscription History */
      GoRoute(
        name: RoutesConstant.subsHistoryPage,
        path: '/${RoutesConstant.subsHistoryPage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");
            return SubscriptionHistory(
              newPage: RoutesConstant.subsHistoryPage,
              oldPage: newPage,
              reqText: '',
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Rent Purchases */
      GoRoute(
        name: RoutesConstant.rentPurchasePage,
        path: '/${RoutesConstant.rentPurchasePage}',
        builder: (context, state) {
          String newPage = "";
          if (state.extra != null && state.extra is String) {
            newPage = state.extra as String;
            printLog("newPage =======> $newPage");
            return MyPurchaselist(
              newPage: RoutesConstant.rentPurchasePage,
              oldPage: newPage,
              reqText: '',
            );
          } else {
            return WebErrorPage(state.error!);
          }
        },
      ),

      /* Payment Success */
      GoRoute(
        name: RoutesConstant.paymentSuccessPage,
        path: '/${RoutesConstant.paymentSuccessPage}',
        builder: (context, state) {
          return const SuccessPage();
        },
      ),

      /* Payment Cancel */
      GoRoute(
        name: RoutesConstant.paymentCancelPage,
        path: '/${RoutesConstant.paymentCancelPage}',
        builder: (context, state) {
          return const CancelPage();
        },
      ),
    ],
    errorBuilder: (context, state) {
      return WebErrorPage(state.error!);
    },
  );
}
