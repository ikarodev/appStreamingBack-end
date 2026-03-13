// To parse this JSON data, do
// final playerModel = playerModelFromJson(jsonString);

import 'dart:convert';

PlayerModel playerModelFromJson(String str) =>
    PlayerModel.fromJson(json.decode(str));

String playerModelToJson(PlayerModel data) => json.encode(data.toJson());

class PlayerModel {
  String? playType;
  bool? isLive;
  int? videoId;
  String? videoTitle;
  int? videoType;
  int? subVideoType;
  int? typeId;
  int? episodeId;
  int? stopTime;
  int? isPremium;
  int? isBuy;
  int? isRent;
  int? rentBuy;
  String? videoUrl;
  String? trailerUrl;
  String? uploadType;
  String? videoThumb;
  String? securityKey;
  String? securityIVKey;

  PlayerModel({
    required this.playType,
    required this.isLive,
    required this.videoId,
    required this.videoTitle,
    required this.videoType,
    required this.subVideoType,
    required this.typeId,
    required this.episodeId,
    required this.stopTime,
    required this.isPremium,
    required this.isBuy,
    required this.isRent,
    required this.rentBuy,
    required this.videoUrl,
    required this.trailerUrl,
    required this.uploadType,
    required this.videoThumb,
    required this.securityKey,
    required this.securityIVKey,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        playType: json["playType"],
        isLive: json["isLive"],
        videoId: json["videoId"],
        videoTitle: json["videoTitle"],
        videoType: json["videoType"],
        subVideoType: json["subVideoType"],
        typeId: json["typeId"],
        episodeId: json["episodeId"],
        stopTime: json["stopTime"],
        isPremium: json["isPremium"],
        isBuy: json["isBuy"],
        isRent: json["isRent"],
        rentBuy: json["rentBuy"],
        videoUrl: json["videoUrl"],
        trailerUrl: json["trailerUrl"],
        uploadType: json["uploadType"],
        videoThumb: json["videoThumb"],
        securityKey: json["securityKey"],
        securityIVKey: json["securityIVKey"],
      );

  Map<String, dynamic> toJson() => {
        "playType": playType,
        "videoId": videoId,
        "isLive": isLive,
        "videoTitle": videoTitle,
        "videoType": videoType,
        "subVideoType": subVideoType,
        "typeId": typeId,
        "episodeId": episodeId,
        "stopTime": stopTime,
        "isPremium": isPremium,
        "isBuy": isBuy,
        "isRent": isRent,
        "rentBuy": rentBuy,
        "videoUrl": videoUrl,
        "trailerUrl": trailerUrl,
        "uploadType": uploadType,
        "videoThumb": videoThumb,
        "securityKey": securityKey,
        "securityIVKey": securityIVKey,
      };
}
