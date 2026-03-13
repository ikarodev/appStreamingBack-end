import 'package:handsplay/utils/utils.dart';
import 'package:handsplay/model/searchmodel.dart';
import 'package:handsplay/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  SearchModel searchModel = SearchModel();

  bool loading = false, isVideoClick = true, isShowClick = false;

  Future<void> getSearchVideo(searchText, type) async {
    printLog("getSearchVideo searchText :==> $searchText");
    printLog("getSearchVideo type :========> $type");
    loading = true;
    searchModel = await ApiService().searchContent(searchText, 1);
    printLog("getSearchVideo status :===> ${searchModel.status}");
    printLog("getSearchVideo message :==> ${searchModel.message}");
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    printLog("setDataVisibility isLoading :==> $isLoading");
    loading = isLoading;
    notifyListeners();
  }

  void setDataVisibility(bool isVideoVisible, bool isShowVisible) {
    printLog("setDataVisibility isVideoVisible :==> $isVideoVisible");
    printLog("setDataVisibility isShowVisible :==> $isShowVisible");
    isVideoClick = isVideoVisible;
    isShowClick = isShowVisible;
    notifyListeners();
  }

  notifyProvider() {
    notifyListeners();
  }

  clearProvider() {
    printLog("============ clearSearchProvider ============");
    searchModel = SearchModel();
    isVideoClick = true;
    isShowClick = false;
  }
}
