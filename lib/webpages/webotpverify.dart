import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/homeprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/provider/sectiondataprovider.dart';
import 'package:yourappname/routes/routes_constant.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webwidget/interactive_icon.dart';
import 'package:yourappname/webwidget/webfooter.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class WebOTPVerify extends StatefulWidget {
  final String? mobileNumber, newPage, oldPage;
  final dynamic reqText;
  const WebOTPVerify(
    this.mobileNumber, {
    super.key,
    required this.newPage,
    required this.oldPage,
    required this.reqText,
  });

  @override
  State<WebOTPVerify> createState() => _WebOTPVerifyState();
}

class _WebOTPVerifyState extends State<WebOTPVerify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPre sharePref = SharedPre();
  late GeneralProvider generalProvider;
  final numberController = TextEditingController();
  final pinPutController = TextEditingController();
  ScrollController scollController = ScrollController();
  String? verificationId, finalOTP, strDeviceType = "3", strDeviceToken;
  int? forceResendingToken;
  bool codeResended = false;

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirebaseConfig();
      codeSend(false);
    });
    _getDeviceToken();
  }
  
  _checkFirebaseConfig() {
    printLog("=== VERIFICANDO CONFIGURAÇÃO FIREBASE ===");
    printLog("Firebase App: ${_auth.app.name}");
    printLog("Firebase Project ID: ${_auth.app.options.projectId}");
    printLog("Firebase API Key: ${_auth.app.options.apiKey}");
    printLog("Firebase Auth Domain: ${_auth.app.options.authDomain}");
    printLog("kIsWeb: $kIsWeb");
    
    if (kIsWeb) {
      printLog("=== VERIFICAÇÃO ESPECÍFICA PARA WEB ===");
      // Verificar se o container do reCAPTCHA existe
      if (kIsWeb) {
        printLog("Container reCAPTCHA deve existir no HTML");
      }
    }
  }

  _getDeviceToken() async {
    String? token = await Utils.getFirebaseWebToken();
    strDeviceToken = token;
    strDeviceType = "3";
    debugPrint("_getDeviceToken strDeviceToken ===> $strDeviceToken");
    debugPrint("_getDeviceToken strDeviceType ====> $strDeviceType");
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: MyImage(
                    imagePath: (MediaQuery.of(context).size.width >
                            MediaQuery.of(context).size.height)
                        ? "login_bg_land.png"
                        : "login_bg_port.png",
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                _buildPageUI(),
              ],
            ),

            /* Footer */
            const SizedBox(height: 20),
            kIsWeb
                ? WebFooter(
                    newPage: widget.newPage,
                    oldPage: widget.oldPage,
                    reqText: '',
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageUI() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width > 1080
            ? (MediaQuery.of(context).size.width * 0.35)
            : ((MediaQuery.of(context).size.width <= 1080 &&
                    (MediaQuery.of(context).size.width > 720))
                ? (MediaQuery.of(context).size.width * 0.5)
                : MediaQuery.of(context).size.width),
        margin: EdgeInsets.fromLTRB(
          Dimens.isBigScreen(context) ? 50 : 20,
          Dimens.isBigScreen(context) ? 50 : 20,
          Dimens.isBigScreen(context) ? 50 : 20,
          Dimens.isBigScreen(context) ? 50 : 20,
        ),
        padding: EdgeInsets.fromLTRB(
          Dimens.isBigScreen(context) ? 30 : 20,
          Dimens.isBigScreen(context) ? 30 : 20,
          Dimens.isBigScreen(context) ? 30 : 20,
          Dimens.isBigScreen(context) ? 30 : 20,
        ),
        alignment: Alignment.center,
        decoration: Utils.setBackground(appBgColor.withValues(alpha: 0.7), 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: InteractiveIcon(builder: (isHovered) {
                return Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    focusColor: white.withValues(alpha: 0.5),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        child: MyImage(
                          fit: BoxFit.contain,
                          imagePath: "backwith_bg.png",
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 15),
            Container(
              width: 180,
              height: 60,
              alignment: Alignment.centerLeft,
              child: MyImage(
                fit: BoxFit.contain,
                imagePath: "appicon.png",
              ),
            ),
            const SizedBox(height: 25),
            MyText(
              color: titleTextColor,
              text: "verifyphonenumber",
              fontsizeNormal: 26,
              fontsizeWeb: 21,
              multilanguage: true,
              fontweight: FontWeight.bold,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
            ),
            const SizedBox(height: 8),
            MyText(
              color: descTextColor,
              text: "code_sent_desc",
              fontsizeNormal: 15,
              fontsizeWeb: 16,
              fontweight: FontWeight.w600,
              maxline: 3,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              multilanguage: true,
              fontstyle: FontStyle.normal,
            ),
            MyText(
              color: descTextColor,
              text: widget.mobileNumber ?? "",
              fontsizeNormal: 15,
              fontsizeWeb: 16,
              fontweight: FontWeight.w600,
              maxline: 3,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              multilanguage: false,
              fontstyle: FontStyle.normal,
            ),
            const SizedBox(height: 40),

            /* Enter Received OTP */
            if (generalProvider.loadingOTP)
              Container(
                height: 50,
                padding: const EdgeInsets.all(3),
                child: Utils.pageLoader(),
              )
            else
              Pinput(
                length: 6,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: pinPutController,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorPrimary, width: 0.7),
                    shape: BoxShape.rectangle,
                    color: edtViewShadowColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  textStyle: kIsWeb
                      ? const TextStyle(
                          color: white,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                        )
                      : GoogleFonts.inter(
                          color: white,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            const SizedBox(height: 30),
            /* Confirm Button */
            if (!generalProvider.loadingOTP)
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  focusColor: white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    printLog(
                        "Clicked sms Code =====> ${pinPutController.text}");
                    if (pinPutController.text.toString().isEmpty) {
                      Utils.showToast("Enter received OTP");
                    } else {
                      _checkOTPAndLogin();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.buttonHeight,
                      decoration: Utils.setGradLTRBGWithBorder(
                          colorPrimary, colorPrimaryDark, transparent, 5, 0),
                      alignment: Alignment.center,
                      child: MyText(
                        color: white,
                        text: "confirm",
                        fontsizeNormal: 17,
                        fontsizeWeb: 19,
                        multilanguage: true,
                        fontweight: FontWeight.w600,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            if (!generalProvider.loadingOTP) const SizedBox(height: 30),

            /* Resend */
            if (!generalProvider.loadingOTP)
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  focusColor: white.withValues(alpha: 0.5),
                  onTap: () {
                    if (!codeResended) {
                      codeSend(true);
                    }
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 70),
                    padding: const EdgeInsets.all(5),
                    child: MyText(
                      color: titleTextColor,
                      text: "resend",
                      multilanguage: true,
                      fontsizeNormal: 16,
                      fontsizeWeb: 18,
                      fontweight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  codeSend(bool isResend) async {
    codeResended = isResend;
    await generalProvider.setLoadingOTP(true);
    if (!mounted) return;
    await phoneSignIn(
        phoneNumber: widget.mobileNumber.toString(), isResend: isResend);
  }

  Future<void> phoneSignIn(
      {required String phoneNumber, required bool isResend}) async {
    try {
      printLog("=== INICIANDO PHONE SIGN IN ===");
      printLog("phoneNumber: $phoneNumber");
      printLog("isResend: $isResend");
      printLog("kIsWeb: $kIsWeb");
      printLog("Firebase Auth: ${_auth.toString()}");
      
      // Validar formato do número de telefone
      if (!phoneNumber.startsWith('+')) {
        throw Exception('Número de telefone deve começar com +');
      }
      
      // Para web, precisamos configurar o reCAPTCHA
      if (kIsWeb) {
        printLog("=== CONFIGURANDO PARA WEB ===");
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: _onVerificationCompleted,
          verificationFailed: _onVerificationFailed,
          codeSent: _onCodeSent,
          codeAutoRetrievalTimeout: _onCodeTimeout,
        );
      } else {
        printLog("=== CONFIGURANDO PARA MOBILE ===");
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          forceResendingToken: forceResendingToken,
          verificationCompleted: _onVerificationCompleted,
          verificationFailed: _onVerificationFailed,
          codeSent: _onCodeSent,
          codeAutoRetrievalTimeout: _onCodeTimeout,
        );
      }
      printLog("=== PHONE SIGN IN CONFIGURADO COM SUCESSO ===");
    } catch (e, stackTrace) {
      printLog("=== ERRO DETALHADO NO PHONE SIGN IN ===");
      printLog("Erro: $e");
      printLog("StackTrace: $stackTrace");
      await generalProvider.setLoadingOTP(false);
      if (!mounted) return;
      
      String errorMessage = "Erro ao enviar SMS: ";
      if (e.toString().contains('network')) {
        errorMessage += "Problema de conexão. Verifique sua internet.";
      } else if (e.toString().contains('invalid-phone-number')) {
        errorMessage += "Número de telefone inválido.";
      } else if (e.toString().contains('quota-exceeded')) {
        errorMessage += "Limite de SMS excedido. Tente mais tarde.";
      } else if (e.toString().contains('app-not-authorized')) {
        errorMessage += "App não autorizado. Verifique as configurações do Firebase.";
      } else {
        errorMessage += e.toString();
      }
      
      Utils.showToast(errorMessage);
    }
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    printLog("verification completed ${authCredential.smsCode}");
    await generalProvider.setLoadingOTP(false);
    if (!mounted) return;
    setState(() {
      finalOTP = authCredential.smsCode ?? "";
      pinPutController.text = authCredential.smsCode ?? "";
      printLog("finalOTP =====> $finalOTP");
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) async {
    printLog("=== FALHA NA VERIFICAÇÃO DO TELEFONE ===");
    printLog("Código do erro: ${exception.code}");
    printLog("Mensagem: ${exception.message}");
    printLog("Detalhes completos: ${exception.toString()}");
    
    await generalProvider.setLoadingOTP(false);
    if (!mounted) return;
    
    String userMessage;
    String debugInfo = "";
    
    switch (exception.code) {
      case 'invalid-phone-number':
        userMessage = "O número de telefone inserido é inválido!";
        debugInfo = "Verifique o formato: deve começar com + e código do país";
        break;
      case 'quota-exceeded':
        userMessage = "Muitas tentativas de SMS. Tente novamente mais tarde.";
        debugInfo = "Limite diário de SMS atingido no Firebase";
        break;
      case 'captcha-check-failed':
        userMessage = "Falha na verificação reCAPTCHA. Recarregue a página e tente novamente.";
        debugInfo = "reCAPTCHA não foi resolvido corretamente";
        break;
      case 'web-context-cancelled':
        userMessage = "Operação cancelada pelo usuário.";
        debugInfo = "Usuário fechou o popup do reCAPTCHA";
        break;
      case 'network-request-failed':
        userMessage = "Erro de rede. Verifique sua conexão e tente novamente.";
        debugInfo = "Problema de conectividade";
        break;
      case 'app-not-authorized':
        userMessage = "App não autorizado para usar autenticação por telefone.";
        debugInfo = "Verificar configurações no Firebase Console: Authentication > Sign-in method > Phone";
        break;
      case 'too-many-requests':
        userMessage = "Muitas tentativas. Aguarde alguns minutos antes de tentar novamente.";
        debugInfo = "Rate limit atingido";
        break;
      case 'unauthorized-domain':
        userMessage = "Domínio não autorizado para autenticação.";
        debugInfo = "Adicionar domínio em Firebase Console > Authentication > Settings > Authorized domains";
        break;
      case 'invalid-api-key':
        userMessage = "Chave de API inválida.";
        debugInfo = "Verificar API key no firebase_options.dart e web/index.html";
        break;
      case 'project-not-found':
        userMessage = "Projeto Firebase não encontrado.";
        debugInfo = "Verificar projectId nas configurações";
        break;
      case 'billing-not-enabled':
        userMessage = "Faturamento não habilitado. SMS requer plano pago no Firebase.";
        debugInfo = "Habilitar billing no Google Cloud Console para envio de SMS";
        break;
      case 'insufficient-permission':
        userMessage = "Permissões insuficientes para envio de SMS.";
        debugInfo = "Verificar configurações de autenticação no Firebase Console";
        break;
      default:
        userMessage = "Erro ao enviar SMS: ${exception.message ?? 'Erro desconhecido'}";
        debugInfo = "Código não mapeado: ${exception.code}";
    }
    
    printLog("Mensagem para usuário: $userMessage");
    printLog("Info debug: $debugInfo");
    
    Utils.showToast(userMessage);
    
    // Log adicional para erro 400
    if (exception.message?.contains('400') == true) {
      printLog("=== ERRO 400 DETECTADO ===");
      printLog("Possíveis causas:");
      printLog("1. Autenticação por telefone não habilitada no Firebase Console");
      printLog("2. Domínio não autorizado");
      printLog("3. API key inválida ou sem permissões");
      printLog("4. Projeto Firebase incorreto");
      printLog("5. reCAPTCHA não configurado corretamente");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) async {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    await generalProvider.setLoadingOTP(false);
    if (!mounted) return;
    printLog("resendingToken =======> ${forceResendingToken.toString()}");
    printLog("code sent");
  }

  _onCodeTimeout(String timeout) async {
    await generalProvider.setLoadingOTP(false);
    if (!mounted) return;
    codeResended = false;
    return null;
  }

  _checkOTPAndLogin() async {
    await generalProvider.setLoadingOTP(false);
    if (!mounted) return;
    bool error = false;
    UserCredential? userCredential;

    printLog("_checkOTPAndLogin verificationId =====> $verificationId");
    printLog("_checkOTPAndLogin smsCode =====> ${pinPutController.text}");
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: pinPutController.text.toString(),
    );

    if (!mounted) return;
    Utils.showProgress(context);
    printLog(
        "phoneAuthCredential.smsCode        =====> ${phoneAuthCredential.smsCode}");
    printLog(
        "phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      printLog(
          "_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Utils.hideProgress();
      printLog("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showToast("Enter valid OTP");
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showToast(
            "Your OTP login session is expired, continue with other logins.");
        return;
      } else {
        error = true;
      }
    }
    printLog(
        "Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      _login(widget.mobileNumber.toString());
    } else {
      if (!mounted) return;
      Utils.hideProgress();
      Utils.showToast("Login fail!!!");
    }
  }

  _login(String mobile) async {
    printLog("_login mobile ==========> $mobile");
    printLog('_login strDeviceType ==>> $strDeviceType');
    printLog('_login strDeviceToken =>> $strDeviceToken');
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);

    await generalProvider.loginWithOTP(
        mobile, Constant.deviceName, strDeviceType, strDeviceToken);

    if (!generalProvider.loading) {
      if (generalProvider.loginOTPModel.status == 200) {
        printLog(
            'loginOTPModel ==>> ${generalProvider.loginOTPModel.toString()}');
        printLog('Login Successfull!');
        Utils.saveUserCreds(
          userID: generalProvider.loginOTPModel.result?[0].id.toString(),
          fullName:
              generalProvider.loginOTPModel.result?[0].fullName.toString() ??
                  "",
          userName:
              generalProvider.loginOTPModel.result?[0].userName.toString() ??
                  "",
          userEmail:
              generalProvider.loginOTPModel.result?[0].email.toString() ?? "",
          userMobile: generalProvider.loginOTPModel.result?[0].mobileNumber
                  .toString() ??
              "",
          userImage:
              generalProvider.loginOTPModel.result?[0].image.toString() ?? "",
          userPremium:
              generalProvider.loginOTPModel.result?[0].isBuy.toString() ?? "",
          userType:
              generalProvider.loginOTPModel.result?[0].type.toString() ?? "",
          deviceType:
              generalProvider.loginOTPModel.result?[0].deviceType.toString(),
          deviceToken:
              generalProvider.loginOTPModel.result?[0].deviceToken.toString(),
        );

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginOTPModel.result?[0].id.toString();
        printLog('Constant userID ==>> ${Constant.userID}');

        await Utils.setUserMode(false);
        await homeProvider.homeNotifyProvider();
        if (!mounted) return;
        await profileProvider.getProfile(context);
        await sectionDataProvider.getSectionBanner("0", "1");
        await sectionDataProvider.getSectionList("0", "1", 1);
        // Hide Progress Dialog
        if (!mounted) return;
        Utils.hideProgress();
        if (!mounted) return;
        if (context.canPop()) {
          printLog("=====================REMOVE=====================");
          context.pop();
          context.pop();
        }
        context.pushReplacementNamed(RoutesConstant.homePage);
      } else {
        if (!mounted) return;
        Utils.hideProgress();
        Utils.showToast(generalProvider.loginOTPModel.message ?? "");
      }
    }
  }
}
