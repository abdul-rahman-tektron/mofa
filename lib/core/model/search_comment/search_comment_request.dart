// To parse this JSON data, do
//
//     final searchCommentRequest = searchCommentRequestFromJson(jsonString);

import 'dart:convert';

SearchCommentRequest searchCommentRequestFromJson(String str) => SearchCommentRequest.fromJson(json.decode(str));

String searchCommentRequestToJson(SearchCommentRequest data) => json.encode(data.toJson());

class SearchCommentRequest {
  String? encryptedId;
  int? nCommentType;
  int? nRoleId;
  int? pageNumber;
  int? pageSize;
  String? search;

  SearchCommentRequest({
    this.encryptedId,
    this.nCommentType,
    this.nRoleId,
    this.pageNumber,
    this.pageSize,
    this.search,
  });

  factory SearchCommentRequest.fromJson(Map<String, dynamic> json) => SearchCommentRequest(
    encryptedId: json["encryptedId"],
    nCommentType: json["n_CommentType"],
    nRoleId: json["n_RoleID"],
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    search: json["search"],
  );

  Map<String, dynamic> toJson() => {
    "encryptedId": encryptedId,
    "n_CommentType": nCommentType,
    "n_RoleID": nRoleId,
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "search": search,
  };
}
