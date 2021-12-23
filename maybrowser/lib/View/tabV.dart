import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/View/downloadV.dart';
import 'package:maybrowser/View/settingV.dart';
import 'package:maybrowser/main.dart';


class TabV extends StatefulWidget {

  TabV({
    required this.key,
    //required Key key,
    required this.tabM
}): super(key: key);

  final GlobalKey<TabVState> key;
  final TabM tabM;


  @override
  TabVState createState() => new TabVState();
}

class TabVState extends State<TabV> with WidgetsBindingObserver{

  var isDialOpen = false;
  String? title = '';
  int? windowId = 0;
  InAppWebViewController? _webViewController;
  bool bottomSheetOpened = false;

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        javaScriptCanOpenWindowsAutomatically: false,
        userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
        transparentBackground: true,
      ),
      android: AndroidInAppWebViewOptions(
        safeBrowsingEnabled: true,
        disableDefaultErrorPage: true,
        supportMultipleWindows: true,
        useHybridComposition: true,///TODO can not use, screen will flash.
        verticalScrollbarThumbColor: const Color.fromRGBO(0, 0, 0, 0.5),
        horizontalScrollbarThumbColor: const Color.fromRGBO(0, 0, 0, 0.5),
      ),
      ios: IOSInAppWebViewOptions(
        allowsLinkPreview: false,
        isFraudulentWebsiteWarningEnabled: true,
        disableLongPressContextMenuOnLinks: true,
        ///allowingReadAccessTo: Uri.parse('file://$WEB_ARCHIVE_DIR/'),
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (GetPlatform.isAndroid) {
          _webViewController?.reload();
        } else if (GetPlatform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _webViewController = null;
    widget.tabM.webViewController = null;

    //_httpAuthUsernameController.dispose();
    //_httpAuthPasswordController.dispose();

    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_webViewController != null && GetPlatform.isAndroid) {
      if (state == AppLifecycleState.paused) {
        pauseAll();
      } else {
        resumeAll();
      }
    }
  }

  void pauseAll() {
    if (GetPlatform.isAndroid) {
      _webViewController?.android.pause();
    }
    pauseTimers();
  }

  void resumeAll() {
    if (GetPlatform.isAndroid) {
      _webViewController?.android.resume();
    }
    resumeTimers();
  }

  void pause() {
    if (GetPlatform.isAndroid) {
      _webViewController?.android.pause();
    }
  }

  void resume() {
    if (GetPlatform.isAndroid) {
      _webViewController?.android.resume();
    }
  }

  void pauseTimers() {
    _webViewController?.pauseTimers();
  }

  void resumeTimers() {
    _webViewController?.resumeTimers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        bool? canBack = await _webViewController?.canGoBack();
        if(bottomSheetOpened){
          return true;
        }else{
          if (isDialOpen) {
            return false;
          } else if(canBack!=null&&canBack){
            _webViewController?.goBack();
            return false;
          }else{
            Get.find<TabRootL>().showHome();
            return false;
          }
        }


      },
      child: Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      ///windowId: this.windowId,
                      initialUrlRequest:
                      URLRequest(url: widget.tabM.url),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,/// useHybridComposition not true
                      onWebViewCreated: (controller) async{
                        widget.tabM.webViewController = controller;
                        _webViewController = controller;
                        await controller.setOptions(options: options);

                        if (GetPlatform.isAndroid) {
                          controller.android.startSafeBrowsing();
                        }

                        widget.tabM.options = await controller.getOptions();

                        Get.find<TabRootL>().updateWebMode(widget.tabM);
                      },

                      onLoadStart: (controller, url) {
                        setState(() {
                          //widget.tabM.isSecure = Util.urlIsSecure(url!);
                          widget.tabM.url = url;
                          widget.tabM.loaded = false;
                          //widget.tabM.setLoadedResources([]);
                          //widget.tabM.setJavaScriptConsoleResults([]);
                          Get.find<TabRootL>().updateWebMode(widget.tabM,);
                        });
                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        //if (![ "http", "https", "file", "chrome",
                        //  "data", "javascript", "about"].contains(uri.scheme)) {
                        //  if (await canLaunch(uri.!)) {
                        //    // Launch the App
                        //    await launch(
                        //      url!,
                        //    );
                        //    // and cancel the request
                        //    return NavigationActionPolicy.CANCEL;
                        //  }
                        //}

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        widget.tabM.url = url;
                        widget.tabM.favicon = null;
                        widget.tabM.loaded = true;
                        pullToRefreshController.endRefreshing();
                        var title = await controller.getTitle();
                        Get.find<TabRootL>().updateWebTitle(title!);
                        setState(() {
                          //urlController.text = this.url!;
                        });

                        ///WebStorageManager webStorageManager = WebStorageManager.instance();
                        ///var a = await webStorageManager.android.getOrigins();
                        ///print(a);
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          //urlController.text = widget.tabM.;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          //this.url = url.toString();
                          //urlController.text = this.url!;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                      ///onDownloadStart: (controller, url){
                      ///  printInfo(info: 'download start');
                      ///},
                      onLongPressHitTestResult: (controller, hitResult)async{
                        var lastHit = await controller.requestFocusNodeHref();
                        print(lastHit);
                        print(hitResult.extra);
                        print(hitResult.type);
                        print(hitResult.isBlank);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
            ])),
        floatingActionButton:
        SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.remove,
          visible: true,
          closeManually: false,
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () {
            ///print('OPENING DIAL');
            this.isDialOpen = true;
          },
          onClose: () {
            ///print('DIAL CLOSED');
            this.isDialOpen = false;
          },
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.star_border),
              backgroundColor: Colors.red,
              //label: 'First',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                //Get.find<TabRootL>().showHome();
                //Get.toNamed(RN.setting);
                _bottomSheet(CollectV(showBottom: true,));
              },
              onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.download_rounded),
              backgroundColor: Colors.blue,
              //label: 'Second',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: (){
                //Get.find<TabRootL>().showHome();
                //Get.toNamed(RN.download,arguments: 0);
                _bottomSheet(DownloadV(showBottom: true,));
              },
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.refresh),
              backgroundColor: Colors.amber,
              onTap: (){
                _webViewController?.reload();
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.arrow_forward),
              backgroundColor: Colors.green,
              //label: 'Third',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                print('THIRD CHILD');
                _webViewController?.goForward();
              },
              onLongPress: () => print('THIRD CHILD LONG PRESS'),
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheet(dynamic newOpen)async{
    bottomSheetOpened = true;
    final PersistentBottomSheetController bottomSheetController = showBottomSheet<void>(context: context, builder: (context){
      return Container(
        height: Get.height*0.85,
        child: newOpen,
      );
    });
    await bottomSheetController.closed.then((value) {
      bottomSheetOpened = false;
    });
  }
}