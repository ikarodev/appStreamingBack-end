import 'dart:async';

import 'package:handsplay/provider/sectionviewallprovider.dart';
import 'package:handsplay/provider/videobyidprovider.dart';
import 'package:handsplay/routes/routes_constant.dart';
import 'package:handsplay/shimmer/shimmerutils.dart';
import 'package:handsplay/utils/dimens.dart';
import 'package:handsplay/utils/utils.dart';
import 'package:handsplay/webpages/webcomman.dart';
import 'package:handsplay/widget/mytext.dart';
import 'package:handsplay/widget/nodata.dart';
import 'package:handsplay/utils/color.dart';
import 'package:handsplay/widget/mynetworkimg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class WebSectionViewAll extends StatefulWidget {
  final int sectionId, videoType;
  final String appBarTitle, screenLayout;
  final String? newPage, oldPage;
  final dynamic reqText;
  const WebSectionViewAll({
    required this.appBarTitle,
    required this.screenLayout,
    required this.sectionId,
    required this.videoType,
    required this.newPage,
    required this.oldPage,
    required this.reqText,
    super.key,
  });

  @override
  State<WebSectionViewAll> createState() => WebSectionViewAllState();
}

class WebSectionViewAllState extends State<WebSectionViewAll> {
  Timer? _timer;
  late SectionViewAllProvider sectionViewAllProvider;

  Future<void> _fetchSectionDetails(int? nextPage) async {
    printLog("_fetchSectionDetails nextPage  ========> $nextPage");
    printLog(
        "_fetchSectionDetails isMorePage  ======> ${sectionViewAllProvider.isMorePage}");
    printLog(
        "_fetchSectionDetails currentPage ======> ${sectionViewAllProvider.currentPage}");
    printLog(
        "_fetchSectionDetails totalPage   ======> ${sectionViewAllProvider.totalPage}");

    await sectionViewAllProvider.getSectionDetails(
        widget.sectionId, (nextPage ?? 0) + 1);
    printLog(
        "sectionDetailsList length ==> ${sectionViewAllProvider.sectionDetailList?.length}");
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    sectionViewAllProvider =
        Provider.of<SectionViewAllProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() async {
    await _fetchSectionDetails(0);
    if (widget.videoType == 3 ||
        widget.videoType == 4 ||
        widget.videoType == 9) {
      _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) async {
        if (sectionViewAllProvider.isMorePage == true) {
          await sectionViewAllProvider.setLoadMore(true);
          await _fetchSectionDetails(sectionViewAllProvider.currentPage ?? 0);
        } else {
          printLog("======== CANCELLED ========");
          timer.cancel();
        }
      });
    } else {
      if (!widget.screenLayout.contains("index")) {
        Future.delayed(const Duration(milliseconds: 400)).then((value) async {
          if (sectionViewAllProvider.isMorePage == true) {
            await sectionViewAllProvider.setLoadMore(true);
            await _fetchSectionDetails(sectionViewAllProvider.currentPage ?? 0);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    sectionViewAllProvider.clearProvider();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebComman(
      newChild: _buildPageUI(),
      newPage: widget.newPage,
      oldPage: widget.oldPage,
      reqText: widget.sectionId.toString(),
    );
  }

  Widget _buildAppbar() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(35, 5, 35, 10),
      child: MyText(
        text: widget.appBarTitle,
        multilanguage: false,
        color: colorPrimary,
        fontsizeNormal: 20,
        fontsizeWeb: 25,
        maxline: 1,
        fontweight: FontWeight.w600,
        fontstyle: FontStyle.normal,
        textalign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPageUI() {
    return Consumer<SectionViewAllProvider>(
        builder: (context, sectionViewAllProvider, child) {
      if (sectionViewAllProvider.loading && !sectionViewAllProvider.loadMore) {
        if (widget.videoType == 3) {
          return ShimmerUtils.responsiveGrid2(
              context,
              Dimens.isBigScreen(context)
                  ? Dimens.heightGenWeb
                  : Dimens.heightGen,
              Dimens.isBigScreen(context)
                  ? Dimens.widthGenWeb
                  : Dimens.widthGen,
              3,
              3,
              3,
              25);
        } else if (widget.videoType == 4 || widget.videoType == 9) {
          return ShimmerUtils.responsiveGrid2(
              context,
              Dimens.isBigScreen(context)
                  ? Dimens.heightChannelWeb
                  : Dimens.heightChannel,
              Dimens.isBigScreen(context)
                  ? Dimens.widthChannelWeb
                  : Dimens.widthChannel,
              3,
              3,
              3,
              25);
        } else {
          return ShimmerUtils.responsiveGrid(
              context,
              Dimens.isBigScreen(context)
                  ? Dimens.heightPortOtherWeb
                  : Dimens.heightPortOther,
              Dimens.isBigScreen(context)
                  ? Dimens.widthPortOtherWeb
                  : Dimens.widthPortOther,
              2,
              Dimens.isBigScreen(context) ? 40 : 20);
        }
      }
      if (sectionViewAllProvider.sectionDetailList == null ||
          (sectionViewAllProvider.sectionDetailList?.length ?? 0) > 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.homeTabHeight),
            _buildAppbar(),
            if (widget.videoType == 3)
              _buildGenres()
            else if (widget.videoType == 4)
              _buildLanguage()
            else if (widget.videoType == 9)
              _buildChannelItem()
            else
              _buildVideoItem(),
            /* Pagination loader */
            if (sectionViewAllProvider.loadMore)
              ShimmerUtils.responsiveGrid(
                  context,
                  Dimens.isBigScreen(context)
                      ? Dimens.heightPortOtherWeb
                      : Dimens.heightPortOther,
                  Dimens.isBigScreen(context)
                      ? Dimens.widthPortOtherWeb
                      : Dimens.widthPortOther,
                  2,
                  10)
            else
              const SizedBox.shrink(),
          ],
        );
      } else {
        return NoData(
          title: (widget.videoType == 3)
              ? 'no_category_title'
              : ((widget.videoType == 4)
                  ? 'no_language_title'
                  : ((widget.videoType == 9) ? 'no_channel_title' : 'no_data')),
          subTitle: (widget.videoType == 3)
              ? 'no_category_desc'
              : ((widget.videoType == 4)
                  ? 'no_language_desc'
                  : ((widget.videoType == 9)
                      ? 'no_channel_desc'
                      : 'no_video_show')),
        );
      }
    });
  }

  Widget _buildVideoItem() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: ResponsiveGridList(
        minItemWidth: Dimens.isBigScreen(context)
            ? Dimens.widthPortOtherWeb
            : Dimens.widthPortOther,
        verticalGridSpacing: 5,
        horizontalGridSpacing: 5,
        minItemsPerRow: 2,
        maxItemsPerRow: 20,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          (sectionViewAllProvider.sectionDetailList?.length ?? 0),
          (position) {
            return Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(Dimens.cardRadiusMedium),
                focusColor: white,
                onTap: () {
                  printLog("Clicked on position ==> $position");
                  Utils.openDetails(
                    context: context,
                    videoId: sectionViewAllProvider
                            .sectionDetailList?[position].id ??
                        0,
                    subVideoType: sectionViewAllProvider
                            .sectionDetailList?[position].subVideoType ??
                        0,
                    videoType: sectionViewAllProvider
                            .sectionDetailList?[position].videoType ??
                        0,
                    typeId: sectionViewAllProvider
                            .sectionDetailList?[position].typeId ??
                        0,
                    newPage: ((sectionViewAllProvider
                                        .sectionDetailList?[position]
                                        .subVideoType ??
                                    0) ==
                                2 ||
                            (sectionViewAllProvider.sectionDetailList?[position]
                                        .videoType ??
                                    0) ==
                                2)
                        ? RoutesConstant.showDetailsPage
                        : RoutesConstant.videoDetailsPage,
                    oldPage: widget.newPage ?? "",
                    reqText: "",
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: Dimens.isBigScreen(context)
                        ? Dimens.widthPortOtherWeb
                        : Dimens.widthPortOther,
                    height: Dimens.isBigScreen(context)
                        ? Dimens.heightPortOtherWeb
                        : Dimens.heightPortOther,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimens.cardRadiusMedium),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: MyNetworkImage(
                        imageUrl: sectionViewAllProvider
                                .sectionDetailList?[position].thumbnail
                                .toString() ??
                            "",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChannelItem() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: ResponsiveGridList(
        minItemWidth: Dimens.isBigScreen(context)
            ? Dimens.widthChannelWeb
            : Dimens.widthChannel,
        verticalGridSpacing: Dimens.isBigScreen(context) ? 20 : 10,
        horizontalGridSpacing: Dimens.isBigScreen(context) ? 20 : 10,
        minItemsPerRow: 3,
        maxItemsPerRow: 20,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          (sectionViewAllProvider.sectionDetailList?.length ?? 0),
          (position) {
            return ClipRRect(
              borderRadius: BorderRadius.circular((Dimens.cardRadiusMedium)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                borderRadius: BorderRadius.circular(Dimens.cardRadiusMedium),
                focusColor: white,
                onTap: () async {
                  printLog("Clicked on position ==> $position");
                  final videoByIDProvider =
                      Provider.of<VideoByIDProvider>(context, listen: false);
                  await videoByIDProvider.setLoading(true);
                  if (!mounted) return;
                  context.pushNamed(
                    RoutesConstant.videoByChannelPage,
                    extra: {
                      'newpage': widget.newPage.toString(),
                      'itemid': (sectionViewAllProvider
                                  .sectionDetailList?[position].id ??
                              0)
                          .toString(),
                      'title': sectionViewAllProvider
                              .sectionDetailList?[position].name ??
                          '',
                      'layouttype': 'ByChannel',
                    },
                  );
                },
                child: Container(
                  height: Dimens.isBigScreen(context)
                      ? Dimens.heightChannelWeb
                      : Dimens.heightChannel,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Dimens.cardRadiusMedium),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: MyNetworkImage(
                      imageUrl: sectionViewAllProvider
                              .sectionDetailList?[position].landscapeImg
                              .toString() ??
                          "",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: ResponsiveGridList(
        minItemWidth: Dimens.isBigScreen(context)
            ? Dimens.widthLangWeb
            : Dimens.widthLangViewAll,
        verticalGridSpacing: Dimens.isBigScreen(context) ? 20 : 10,
        horizontalGridSpacing: Dimens.isBigScreen(context) ? 20 : 10,
        minItemsPerRow: 3,
        maxItemsPerRow: 20,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          (sectionViewAllProvider.sectionDetailList?.length ?? 0),
          (position) {
            return Container(
              height: Dimens.isBigScreen(context)
                  ? Dimens.heightLangWeb
                  : Dimens.heightLangViewAll,
              width: Dimens.isBigScreen(context)
                  ? Dimens.widthLangWeb
                  : Dimens.widthLangViewAll,
              alignment: Alignment.center,
              child: InkWell(
                borderRadius: BorderRadius.circular((Dimens.isBigScreen(context)
                        ? Dimens.heightLangWeb
                        : Dimens.heightLangViewAll) /
                    2),
                focusColor: white,
                onTap: () async {
                  printLog("Clicked on position ==> $position");
                  final videoByIDProvider =
                      Provider.of<VideoByIDProvider>(context, listen: false);
                  await videoByIDProvider.setLoading(true);
                  if (!mounted) return;
                  context.pushNamed(
                    RoutesConstant.videoByLanguagePage,
                    extra: {
                      'newpage': widget.newPage.toString(),
                      'itemid': (sectionViewAllProvider
                                  .sectionDetailList?[position].id ??
                              0)
                          .toString(),
                      'title': sectionViewAllProvider
                              .sectionDetailList?[position].name ??
                          '',
                      'layouttype': 'ByLanguage',
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      (Dimens.isBigScreen(context)
                              ? Dimens.heightLangWeb
                              : Dimens.heightLangViewAll) /
                          2),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: MyNetworkImage(
                    imageUrl: sectionViewAllProvider
                            .sectionDetailList?[position].image
                            .toString() ??
                        "",
                    fit: BoxFit.contain,
                    height: Dimens.isBigScreen(context)
                        ? Dimens.heightLangWeb
                        : Dimens.heightLangViewAll,
                    width: Dimens.isBigScreen(context)
                        ? Dimens.widthLangWeb
                        : Dimens.widthLangViewAll,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenres() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: ResponsiveGridList(
        minItemWidth:
            Dimens.isBigScreen(context) ? Dimens.widthGenWeb : Dimens.widthGen,
        verticalGridSpacing: Dimens.isBigScreen(context) ? 20 : 10,
        horizontalGridSpacing: Dimens.isBigScreen(context) ? 20 : 10,
        minItemsPerRow: 3,
        maxItemsPerRow: 20,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          (sectionViewAllProvider.sectionDetailList?.length ?? 0),
          (position) {
            return Container(
              height: Dimens.isBigScreen(context)
                  ? Dimens.heightGenWeb
                  : Dimens.heightGen,
              width: Dimens.isBigScreen(context)
                  ? Dimens.widthGenWeb
                  : Dimens.widthGen,
              alignment: Alignment.center,
              child: InkWell(
                focusColor: white,
                borderRadius: BorderRadius.circular((Dimens.isBigScreen(context)
                        ? Dimens.heightGenWeb
                        : Dimens.heightGen) /
                    2),
                onTap: () async {
                  printLog("Clicked on position ==> $position");
                  final videoByIDProvider =
                      Provider.of<VideoByIDProvider>(context, listen: false);
                  await videoByIDProvider.setLoading(true);
                  if (!mounted) return;
                  context.pushNamed(
                    RoutesConstant.videoByLanguagePage,
                    extra: {
                      'newpage': widget.newPage.toString(),
                      'itemid': (sectionViewAllProvider
                                  .sectionDetailList?[position].id ??
                              0)
                          .toString(),
                      'title': sectionViewAllProvider
                              .sectionDetailList?[position].name ??
                          '',
                      'layouttype': 'ByCategory',
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      (Dimens.isBigScreen(context)
                              ? Dimens.heightGenWeb
                              : Dimens.heightGen) /
                          2),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: MyNetworkImage(
                    imageUrl: sectionViewAllProvider
                            .sectionDetailList?[position].image
                            .toString() ??
                        "",
                    fit: BoxFit.cover,
                    height: Dimens.isBigScreen(context)
                        ? Dimens.heightGenWeb
                        : Dimens.heightGen,
                    width: Dimens.isBigScreen(context)
                        ? Dimens.widthGenWeb
                        : Dimens.widthGen,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
