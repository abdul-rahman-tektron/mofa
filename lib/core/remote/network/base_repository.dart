import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mofa/core/remote/network/network_provider.dart';

class BaseRepository with ChangeNotifier {
  final networkProvider = NetworkProvider();

  final headerAccept = {
    HttpHeaders.acceptHeader: "application/json",
  };
  final headerContentTypeAndAcceptPayment = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json",
  };
  final headerContentTypeAndAccept = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json"
  };
  final headerContentTypeAndAcceptAUS = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json"
  };
  final headerPDFContentTypeAndAccept = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json, text/plain, */*",
    HttpHeaders.acceptEncodingHeader: "gzip, deflate, br",
    HttpHeaders.connectionHeader: "keep-alive"
  };
  final Map<String, String> mapAuthHeader = {
    HttpHeaders.authorizationHeader: 'Bearer nhl8gwc8vtee0bookm2vbkw31enngxhj'
  };

  final headerFormDataWithAccept = {
    HttpHeaders.contentTypeHeader: "multipart/form-data",
    HttpHeaders.acceptHeader: "application/json",
  };

  Map<String, String> buildDefaultHeaderWithToken(String token) {
    Map<String, String> header = headerContentTypeAndAccept;
    header.remove(HttpHeaders.authorizationHeader);
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => getFormattedToken(token));
    return header;
  }

  Map<String, String> buildDefaultPDFHeaderWithToken(String token) {
    Map<String, String> header = headerPDFContentTypeAndAccept;
    header.remove(HttpHeaders.authorizationHeader);
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => getFormattedToken(token));
    return header;
  }

  Map<String, String> buildDefaultHeaderWithTokenXML(String token) {
    Map<String, String> header = headerContentTypeAndAccept;
    header.remove(HttpHeaders.authorizationHeader);
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => getFormattedToken(token));
    return header;
  }

  final headerUrlEncodedWithCredentials = {
    HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded; charset=UTF-8",
    HttpHeaders.acceptHeader: "*/*",
    // 'Cookie': '.dntCaptcha10104d2c164d476ab2c22f4ea2eddf957533=uLOnRHr7WsAga3ryexFtpFvhuLxJmG5pf21z8H1zpShP0qglISkODsa_YyKP3gl2HHWN9IwifR9IiyAKW52SpxbBoMJeSbnA; .dntCaptchae9b1a99a03a74359b847e680f9b6b8ef8901=OK-Ja2UeyyDcp0oghfLdDP77EvI5qoY5xiWe6VRvugchf2N9Gkl1jhHhFSwffOjHP_U2gDyQa7BQ7fLKSkInlfegsyDA1MIn; .dntCaptcha4ce9e34a5535454f86a0a4bb97d0cc658597=zylVuyVxadTAJ38aFp0IL68IhDYqhvL9G21szJqkT1XbdP0GzWBby5356oYMZFViuqoUVTm1A5VMn7s7DkxhiqaweNzFqzFr', // Optional: only if your backend expects this as a header
  };

  final headerContentTypeAndAcceptWithCredentials = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json",
    // 'Cookie': '.dntCaptcha10104d2c164d476ab2c22f4ea2eddf957533=uLOnRHr7WsAga3ryexFtpFvhuLxJmG5pf21z8H1zpShP0qglISkODsa_YyKP3gl2HHWN9IwifR9IiyAKW52SpxbBoMJeSbnA; .dntCaptchae9b1a99a03a74359b847e680f9b6b8ef8901=OK-Ja2UeyyDcp0oghfLdDP77EvI5qoY5xiWe6VRvugchf2N9Gkl1jhHhFSwffOjHP_U2gDyQa7BQ7fLKSkInlfegsyDA1MIn; .dntCaptcha4ce9e34a5535454f86a0a4bb97d0cc658597=zylVuyVxadTAJ38aFp0IL68IhDYqhvL9G21szJqkT1XbdP0GzWBby5356oYMZFViuqoUVTm1A5VMn7s7DkxhiqaweNzFqzFr', // Optional: only if your backend expects this as a header
  };

  final headerUrlEncoded = {
    HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    HttpHeaders.acceptHeader: "application/json",
  };

  Map<String, String> buildFormDataHeaderWithToken(String token) {
    final header = Map<String, String>.from(headerFormDataWithAccept);
    header[HttpHeaders.authorizationHeader] = getFormattedToken(token);
    return header;
  }

  String getFormattedToken(String token) {
    return 'Bearer $token';
  }
}
