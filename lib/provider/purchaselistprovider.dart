import 'package:handsplay/utils/utils.dart';
import 'package:handsplay/model/rentmodel.dart';
import 'package:handsplay/utils/constant.dart';
import 'package:handsplay/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class PurchaselistProvider extends ChangeNotifier {
  RentModel rentModel = RentModel();
  List<Result>? contentList = [];
  bool loading = false;

  /* Post Pagination */
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  setLoading(loading) {
    this.loading = loading;
    notifyListeners();
  }

  Future<void> getUserRentVideoList(pageNo) async {
    printLog("getUserRentVideoList userID :======> ${Constant.userID}");
    printLog("getUserRentVideoList pageNo =======> $pageNo");
    if (pageNo == 1) {
      contentList = [];
    }
    loading = true;
    rentModel = RentModel();
    rentModel = await ApiService().userRentVideoList(pageNo);
    printLog("rentModel length :=1=> ${(rentModel.result?.length ?? 0)}");
    if (rentModel.status == 200) {
      setPagination(rentModel.totalRows, rentModel.totalPage,
          rentModel.currentPage, rentModel.morePage);
      if (rentModel.result != null && (rentModel.result?.length ?? 0) > 0) {
        printLog("rentModel length :=2=> ${(rentModel.result?.length ?? 0)}");
        for (var i = 0; i < (rentModel.result?.length ?? 0); i++) {
          contentList?.add(rentModel.result?[i] ?? Result());
        }
        final Map<String, Result> postMap = {};
        contentList?.forEach((item) {
          final key =
              '${item.id}-${item.typeId}-${item.videoType}-${item.subVideoType}';
          postMap[key] = item;
        });
        contentList = postMap.values.toList();
        await setLoadMore(false);
        printLog("rentModel length :=3=> ${(rentModel.result?.length ?? 0)}");
      } else {
        await setLoadMore(false);
      }
    } else {
      await setLoadMore(false);
    }
    loading = false;
    notifyListeners();
  }

  setLoadMore(loadMore) {
    printLog("setLoadMore loadMore :=> $loadMore");
    this.loadMore = loadMore;
    notifyListeners();
  }

  setPagination(
      int? totalRows, int? totalPage, int? currentPage, bool? morePage) {
    printLog("setPagination currentPage :==> $currentPage");
    printLog("setPagination totalRows :====> $totalRows");
    printLog("setPagination totalPage :====> $totalPage");
    printLog("setPagination morePage :=====> $morePage");
    this.currentPage = currentPage;
    this.totalRows = totalRows;
    this.totalPage = totalPage;
    isMorePage = morePage;
    notifyListeners();
  }

  clearProvider() {
    printLog("<================ clearProvider ================>");
    rentModel = RentModel();
    loading = false;
    loadMore = false;
    totalRows = null;
    totalPage = null;
    currentPage = null;
    isMorePage = null;
  }
}
