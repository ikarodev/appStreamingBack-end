import 'package:handsplay/model/avatarmodel.dart';
import 'package:handsplay/webservice/apiservices.dart';
import 'package:flutter/material.dart';
import 'package:handsplay/utils/utils.dart';

class AvatarProvider extends ChangeNotifier {
  AvatarModel avatarModel = AvatarModel();

  bool loading = false;

  setLoading(isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> getAvatar() async {
    loading = true;
    avatarModel = await ApiService().getAvatar();
    printLog("getAvatar status :==> ${avatarModel.status}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    avatarModel = AvatarModel();
  }
}
