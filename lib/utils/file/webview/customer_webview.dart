import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomerWebView extends StatefulWidget {
  final String url;

  const CustomerWebView({super.key, required this.url});

  @override
  State<CustomerWebView> createState() => _CustomerWebViewState();
}

class _CustomerWebViewState extends State<CustomerWebView> {
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    intiWebViewData();
    super.initState();
  }

  intiWebViewData() async {
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return SafeArea(
        child: Stack(
      alignment: Alignment.topLeft,
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          // onLoadStart: (controller, url) {
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          // androidOnPermissionRequest: (controller, origin, resources) async {
          //   return PermissionRequestResponse(
          //       resources: resources,
          //       action: PermissionRequestResponseAction.GRANT);
          // },
          // shouldOverrideUrlLoading: (controller, navigationAction) async {
          //   var uri = navigationAction.request.url!;
          //
          //   if (![ "http", "https", "file", "chrome",
          //     "data", "javascript", "about"].contains(uri.scheme)) {
          //     if (await canLaunch(url)) {
          //       // Launch the App
          //       await launch(
          //         url,
          //       );
          //       // and cancel the request
          //       return NavigationActionPolicy.CANCEL;
          //     }
          //   }
          //
          //   return NavigationActionPolicy.ALLOW;
          // },
          // onLoadStop: (controller, url) async {
          //   pullToRefreshController.endRefreshing();
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          onLoadError: (controller, url, code, message) {
            pullToRefreshController.endRefreshing();
          },
          // onProgressChanged: (controller, progress) {
          //   if (progress == 100) {
          //     pullToRefreshController.endRefreshing();
          //   }
          //   setState(() {
          //     this.progress = progress / 100;
          //     urlController.text = this.url;
          //   });
          // },
          // onUpdateVisitedHistory: (controller, url, androidIsReload) {
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: const Icon(
              Icons.navigate_before,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ));
  }
}
