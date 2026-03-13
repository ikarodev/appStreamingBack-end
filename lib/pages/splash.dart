import 'package:handsplay/pages/bottombar.dart';
import 'package:handsplay/pages/intro.dart';
import 'package:handsplay/provider/connectivityprovider.dart';
import 'package:handsplay/provider/generalprovider.dart';
import 'package:handsplay/provider/homeprovider.dart';
import 'package:handsplay/routes/routes_constant.dart';
import 'package:handsplay/webpages/webhome.dart';
import 'package:handsplay/utils/color.dart';
import 'package:handsplay/utils/constant.dart';
import 'package:handsplay/utils/utils.dart';
import 'package:handsplay/widget/myimage.dart';
import 'package:handsplay/utils/sharedpre.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  late GeneralProvider generalProvider;
  late ConnectivityProvider connectivityProvider;
  String? seen;
  SharedPre sharedPre = SharedPre();

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  _getData() async {
    if (connectivityProvider.isOnline) {
      await generalProvider.getGeneralsetting(context);
    }

    if (!mounted) return;
    isFirstCheck();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        color: appBgColor,
        child: MyImage(
          imagePath: (kIsWeb || Constant.isTV) ? "appicon.png" : "splash.png",
          fit: (kIsWeb || Constant.isTV) ? BoxFit.contain : BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> isFirstCheck() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.setLoading(true);
    String? introScreenStatus =
        await Utils.configByStatus(status: Constant.introScreenStatus);
    printLog('introScreenStatus ==> $introScreenStatus');

    seen = await sharedPre.read('seen') ?? "0";
    printLog('seen ==> $seen');
    printLog(
        'introScreenModel length ==> ${generalProvider.introScreenModel.result?.length}');
    if (!mounted) return;
    if (kIsWeb || Constant.isTV) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WebHome(
              newPage: RoutesConstant.homePage,
              oldPage: RoutesConstant.homePage,
              reqText: '',
            );
          },
        ),
      );
    } else {
      if (introScreenStatus == "1") {
        if (seen == "1") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const Bottombar();
              },
            ),
          );
        } else {
          if (generalProvider.introScreenModel.result != null &&
              (generalProvider.introScreenModel.result?.length ?? 0) > 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Intro();
                },
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Bottombar();
                },
              ),
            );
          }
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bottombar();
            },
          ),
        );
      }
    }
  }
}
