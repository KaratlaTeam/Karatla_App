import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:maybrowser/View/tabV.dart';

class TabRootM {
  TabRootM({
    required this.tabVList,
    required this.showIndex
});

  List<TabV> tabVList;
  int showIndex;
}

class TabM{
  Uri? _url;
  String? _title;
  Favicon? _favicon;
  late double _progress;
  late bool _loaded;
  late bool _isDesktopMode;
  late bool _isIncognitoMode;
  late List<Widget> _javaScriptConsoleResults;
  late List<String> _javaScriptConsoleHistory;
  late List<LoadedResource> _loadedResources;
  late bool _isSecure;
  int windowId;
  InAppWebViewGroupOptions? options;
  InAppWebViewController? webViewController;
  Uint8List? screenshot;
  bool needsToCompleteInitialLoad;

  TabM({
    Uint8List? screenshot,
    Uri? url,
    String? title = '',
    Favicon? favicon,
    double progress = 0.0,
    bool loaded = false,
    bool isDesktopMode = false,
    bool isIncognitoMode = false,
    List<Widget>? javaScriptConsoleResults,
    List<String>? javaScriptConsoleHistory,
    List<LoadedResource>? loadedResources,
    bool isSecure = false,
    required this.windowId,
    this.options,
    this.webViewController,
    this.needsToCompleteInitialLoad = true,
  }) {
    _url = url;
    _favicon = favicon;
    _progress = progress;
    _loaded = loaded;
    _isDesktopMode = isDesktopMode;
    _isIncognitoMode = isIncognitoMode;
    _javaScriptConsoleResults = javaScriptConsoleResults ?? <Widget>[];
    _javaScriptConsoleHistory = javaScriptConsoleHistory ?? <String>[];
    _loadedResources = loadedResources ?? <LoadedResource>[];
    _isSecure = isSecure;
    options = options ?? InAppWebViewGroupOptions();
  }


  Uri? get url => _url;

  set url(Uri? value) {
    if (value != _url) {
      _url = value;
    }
  }


  String? get title => _title;

  set title(String? value) {
    if (value != _title) {
      _title = value;
    }
  }

  Favicon? get favicon => _favicon;

  set favicon(Favicon? value) {
    if (value != _favicon) {
      _favicon = value;
    }
  }

  double get progress => _progress;

  set progress(double value) {
    if (value != _progress) {
      _progress = value;
    }
  }

  bool get loaded => _loaded;

  set loaded(bool value) {
    if (value != _loaded) {
      _loaded = value;
    }
  }

  bool get isDesktopMode => _isDesktopMode;

  set isDesktopMode(bool value) {
    if (value != _isDesktopMode) {
      _isDesktopMode = value;
    }
  }

  bool get isIncognitoMode => _isIncognitoMode;

  set isIncognitoMode(bool value) {
    if (value != _isIncognitoMode) {
      _isIncognitoMode = value;
    }
  }

  bool get isSecure => _isSecure;

  set isSecure(bool value) {
    if (value != _isSecure) {
      _isSecure = value;
    }
  }

  void updateWithValue(TabM tabM) {
    url = tabM.url;
    title = tabM.title;
    favicon = tabM.favicon;
    progress = tabM.progress;
    loaded = tabM.loaded;
    isDesktopMode = tabM.isDesktopMode;
    isIncognitoMode = tabM.isIncognitoMode;
   isSecure = tabM.isSecure;
    options = tabM.options;
    webViewController = tabM.webViewController;
  }

  static TabM? fromMap(Map<String, dynamic>? map) {
    return map != null ? TabM(
      url: map["url"] != null ? Uri.parse(map["url"]) : null,
      title: map["title"],
      favicon: map["favicon"] != null ? Favicon(
        url: Uri.parse(map["favicon"]["url"]),
        rel: map["favicon"]["rel"],
        width: map["favicon"]["width"],
        height: map["favicon"]["height"],
      ) : null,
      progress: map["progress"],
      isDesktopMode: map["isDesktopMode"],
      isIncognitoMode: map["isIncognitoMode"],
      javaScriptConsoleHistory: map["javaScriptConsoleHistory"]?.cast<String>(),
      isSecure: map["isSecure"],
      options: InAppWebViewGroupOptions.fromMap(map["options"]),
      windowId: map["windowId"],
    ) : null;
  }

  Map<String, dynamic> toMap() {
    return {
      "url": _url?.toString(),
      "title": _title,
      "favicon": _favicon?.toMap(),
      "progress": _progress,
      "isDesktopMode": _isDesktopMode,
      "isIncognitoMode": _isIncognitoMode,
      "javaScriptConsoleHistory": _javaScriptConsoleHistory,
      "isSecure": _isSecure,
      "options": options?.toMap(),
      "screenshot": screenshot,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }


}