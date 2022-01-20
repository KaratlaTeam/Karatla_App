
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/View/downloadV.dart';
import 'package:share/share.dart';


class TabV extends StatefulWidget {

  TabV({
    required this.key,
    required this.tabM,
}): super(key: key);

  final GlobalKey<TabVState> key;
  final TabM tabM;


  @override
  TabVState createState() => new TabVState();
}

class TabVState extends State<TabV> with WidgetsBindingObserver{

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useOnLoadResource: true,
        useShouldOverrideUrlLoading: true,
        javaScriptCanOpenWindowsAutomatically: true,
        userAgent: "Mozilla/5.0 (Linux; Android 9; Ios; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
        //transparentBackground: true,
        useShouldInterceptAjaxRequest: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
      ),
      android: AndroidInAppWebViewOptions(
        safeBrowsingEnabled: true,
        disableDefaultErrorPage: true,
        supportMultipleWindows: true,
        useHybridComposition: true,///TODO can not use, screen will flash.
        //verticalScrollbarThumbColor: const Color.fromRGBO(0, 0, 0, 0.5),
        //horizontalScrollbarThumbColor: const Color.fromRGBO(0, 0, 0, 0.5),
      ),
      ios: IOSInAppWebViewOptions(
        allowsLinkPreview: false,
        isFraudulentWebsiteWarningEnabled: true,
        disableLongPressContextMenuOnLinks: true,
        ///allowingReadAccessTo: Uri.parse('file://$WEB_ARCHIVE_DIR/'),
      ));

  var isDialOpen = false;
  String title = '';
  String uri = '';
  bool bottomSheetOpened = false;
  var position;
  late TabRootL _ ;

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  final urlController = TextEditingController();

  ReceivePort _port = ReceivePort();


  @override
  void initState() {
    _ = Get.find<TabRootL>();
    WidgetsBinding.instance!.addObserver(this);
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (GetPlatform.isAndroid) {
          widget.tabM.webViewController?.reload();
        } else if (GetPlatform.isIOS) {
          widget.tabM.webViewController?.loadUrl(
              urlRequest: URLRequest(url: await widget.tabM.webViewController?.getUrl()));
        }
      },
    );

    /// Download bind
       _bindBackgroundIsolate();
       FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    widget.tabM.webViewController = null;
    WidgetsBinding.instance!.removeObserver(this);
    _unbindBackgroundIsolate();
    //_httpAuthUsernameController.dispose();
    //_httpAuthPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.tabM.webViewController != null && GetPlatform.isAndroid) {
      if (state == AppLifecycleState.paused) {
        pauseAll();
      } else {
        resumeAll();
      }
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async{
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];
      print('Task Progress: $progress');
      if(progress == 100){
        await Get.find<TabRootL>().getAllFilesDataList();
        //Get.showSnackbar(GetSnackBar(title: 'Inform', message: 'Download Successful', duration: Duration(seconds: 1),));
        print('task id: $id complete');
        print('state: $status');
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }


  void pauseAll() {
    if (GetPlatform.isAndroid) {
      pause();
    }
    pauseTimers();
  }

  void resumeAll() {
    if (GetPlatform.isAndroid) {
      resume();
    }
    resumeTimers();
  }

  void pause() {
    if (GetPlatform.isAndroid) {
      widget.tabM.webViewController?.android.pause();
    }
  }

  void resume() {
    if (GetPlatform.isAndroid) {
      widget.tabM.webViewController?.android.resume();
    }
  }

  void pauseTimers() {
    widget.tabM.webViewController?.pauseTimers();
  }

  void resumeTimers() {
    widget.tabM.webViewController?.resumeTimers();
  }

  Future<void> webScreenShot()async{
    widget.tabM.screenshot  = await widget.tabM
        .webViewController!
        .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration(compressFormat: CompressFormat.JPEG,quality: 20))
        .timeout(Duration(milliseconds: 500), onTimeout: () => null,);
  }

  String? getTitle(){
    String? title = widget.tabM.title;
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        bool? canBack = await widget.tabM.webViewController?.canGoBack();
        if(_.tabS?.rootIndex == 0){
          if(bottomSheetOpened){
            return true;
          }else{
            if (isDialOpen) {
              return false;
            } else {
              if(canBack!=null&&canBack){
                widget.tabM.webViewController?.goBack();
                return false;
              }else {
                int? index = _.tabS?.tabRootM.showIndex;
                if( index == 0){
                  _.showHome();
                  _.removeTabView();
                  return false;
                }else{
                  _.removeTabView();
                  return false;
                }
              }
            }
          }
        }else if(_.tabS?.rootIndex == 1){
          int? l = _.tabS?.tabRootM.tabVList.length;
          if(l! > 0){
            _.showWeb();
            return false;
          }else{
            _.showHome();
            return false;
          }

        }else if(_.tabS?.rootIndex == 2){

          return true;
        }else{
          return true;
        }


      },
      child: InkWell(
        onTapDown: (details){
          print('tapDown: $details');
          position = details.globalPosition;
          setState(() {});
        },
        child: Scaffold(
          body: SafeArea(
              child: Column(children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        initialUrlRequest: URLRequest(url: widget.tabM.url),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,/// useHybridComposition not true
                        onWebViewCreated: (controller) async{
                          if (GetPlatform.isAndroid) {
                            controller.android.startSafeBrowsing();
                          }
                          widget.tabM.webViewController = controller;
                        },

                        onLoadStart: (controller, url) {
                          setState(() {
                            //widget.tabM.isSecure = Util.urlIsSecure(url!);
                            widget.tabM.url = url;
                            widget.tabM.loaded = false;
                          });
                        },
                        onDownloadStart: (controller, url)async{
                          String dropdownValue = 'File';
                          Get.defaultDialog(
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Please choose download Directory'),
                                  StatefulBuilder(
                                    builder: (context, setState){
                                      return DropdownButton<String>(
                                        value: dropdownValue,
                                        //icon: const Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black
                                        ),
                                        underline: Container(
                                          height: 0,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: <String>['File', 'Picture', 'Video', 'Music']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              onConfirm: ()async{
                                print("Download path: "+url.path);
                                String path = url.path;
                                String fileName = path.substring(path.lastIndexOf('/') + 1);
                                print("File name: $fileName");
                                final taskId = await FlutterDownloader.enqueue(
                                  url: url.toString(),
                                  fileName: fileName,
                                  savedDir: Get.find<TabRootL>().getPath(dropdownValue).toString(),
                                  showNotification: true,
                                  openFileFromNotification: true,
                                );

                                Get.back();
                              }
                          );


                        },
                        androidOnPermissionRequest: (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
                          print('new to go: $uri');

                          return NavigationActionPolicy.ALLOW;
                        },
                        onReceivedHttpAuthRequest: (controller,challenge)async{
                          print('onReceivedHttpAuthRequest');
                        },
                        onReceivedClientCertRequest: (controller,challenge)async{
                          print('onReceivedClientCertRequest');
                        },
                        onReceivedServerTrustAuthRequest: (controller,challenge)async{
                          print('onReceivedServerTrustAuthRequest');
                        },
                        onCreateWindow: (controller, createWindowRequest)async{
                          var l = createWindowRequest.request.url;
                          print('new window: $l');
                          //Get.find<TabRootL>().addTabView(l.toString());
                          return true;
                        },
                        onLoadStop: (controller, url) async {
                          var favicons = await controller.getFavicons();
                          widget.tabM.url = url;
                          widget.tabM.favicon = favicons.first;
                          widget.tabM.loaded = true;
                          widget.tabM.title = (await controller.getTitle())!;
                          this.uri = url.toString();
                          _.addHistory([title, this.uri]);
                          pullToRefreshController.endRefreshing();
                          //setState(() {
                          //  //urlController.text = this.url!;
                          //});

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
                        onLongPressHitTestResult: (controller, hitResult)async{
                          var lastHit = await controller.requestFocusNodeHref();
                          bool type = false;
                          var url = hitResult.extra;
                          var x = await controller.getScrollX();
                          var y = await controller.getScrollY();
                          print('Scroll: $x, $y');
                          print(await controller.getTitle());
                          print('hit position: $position');
                          print('lastHit: $lastHit');
                          print(hitResult.extra);
                          print(hitResult.type);
                          print(hitResult.isBlank);

                          if(hitResult.type == InAppWebViewHitTestResultType.IMAGE_TYPE || hitResult.type == InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE){
                            type = true;
                          }

                          InAppWebViewHitTestResultType.UNKNOWN_TYPE == hitResult.type ?
                          print('On know') :
                          Get.defaultDialog(
                            title: '',
                            content: Center(
                              child: Container(
                                //height: 125,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: ()async{
                                        await webScreenShot();
                                        _.addTabView(url!);
                                        Get.back();
                                      },
                                      child: Text('Open new tab'),
                                    ),

                                    !type ?
                                    Container() :
                                    ElevatedButton(
                                      onPressed: ()async{
                                        int index = url!.lastIndexOf('.');
                                        var nameType = url.substring(index);
                                        var now = DateTime.now();
                                        String name = now.year.toString()+now.month.toString()+now.day.toString()+now.hour.toString()+now.minute.toString()+now.second.toString()+nameType;
                                        print('save image: '+name);

                                        GetPlatform.isAndroid ?
                                        Dio().download(url, _.getPath('Picture').toString()+'/'+name).then((value) async{
                                          print(_.getPath('Picture').toString()+'/'+name);
                                          print(value.statusMessage);
                                          await _.getAllFilesDataList();
                                          setState(() {});
                                        }) :
                                        await FlutterDownloader.enqueue(
                                          url: url.toString(),
                                          fileName: name,
                                          savedDir: _.getPath('Picture').toString(),
                                          showNotification: true,
                                          openFileFromNotification: true,
                                        );
                                        Get.back();
                                      },
                                      child: Text('Save image'),
                                    ),
                                    ElevatedButton(
                                      onPressed: ()async{
                                        Share.share(url!);
                                        Get.back();
                                      },
                                      child: Text('Share'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        onAjaxReadyStateChange: (c,a)async{print('onAjaxReadyStateChange');},
                        onLoadHttpError: (c,a,l,b){print('onLoadHttpError: $b');},
                        onLoadResource: (c,resource)async{
                          if(resource.initiatorType == 'video'){
                            print('onLoadResource: $resource');
                            Get.showSnackbar(GetSnackBar(
                              title: 'Find Video',
                              messageText: Container(child: Row(children: [
                                TextButton(onPressed: ()async{
                                  var url = resource.url;
                                  var name = DateTime.now().hour.toString()
                                      +DateTime.now().minute.toString()
                                      +DateTime.now().second.toString();//await _webViewController?.getTitle();
                                  //final d = Dio().downloadUri(url!,'${Get.find<TabRootL>().systemS?.videoPath}/${name.toString()}.mp4').then((value) {
                                  //  print(value.statusMessage);
                                  //  if(value.statusMessage == 'OK'){
                                  //    Get.showSnackbar(GetSnackBar(title: 'Result', message: '$name Download Successful', duration: Duration(seconds: 1),));
                                  //  }
                                  //});
                                  final taskId = await FlutterDownloader.enqueue(
                                    url: url.toString(),
                                    fileName: name+".mp4",
                                    savedDir: Get.find<TabRootL>().getPath('Video').toString(),
                                    showNotification: true,
                                    openFileFromNotification: true,
                                  );
                                }, child: Text('Download')),
                              ],),width: 50,),
                              duration: Duration(seconds: 5),
                            ));
                          }
                        },
                        onTitleChanged: (c,a)async{
                          print('onTitleChanged: $a');
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
            tooltip: 'Speed Dial${widget.tabM.windowId}',
            heroTag: 'speed-dial-hero-tag${widget.tabM.windowId}',
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
                  Get.find<TabRootL>().addCollect([title,this.uri]);
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
                  widget.tabM.webViewController?.reload();
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.arrow_forward),
                backgroundColor: Colors.green,
                //label: 'Third',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  print('THIRD CHILD');
                  widget.tabM.webViewController?.goForward();
                },
                onLongPress: () => print('THIRD CHILD LONG PRESS'),
              ),
            ],
          ),
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