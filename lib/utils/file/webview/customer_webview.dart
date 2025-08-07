import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomerWebView extends StatefulWidget {
  final String url;

  const CustomerWebView({super.key, required this.url});

  @override
  State<CustomerWebView> createState() => _CustomerWebViewState();
}

class _CustomerWebViewState extends State<CustomerWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  @override
  void initState() {
    super.initState();
    webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(widget.url)));
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
          key: webViewKey,
          // webViewEnvironment: webViewEnvironment,
          initialUrlRequest:
          URLRequest(url: WebUri(widget.url)),
          // initialUrlRequest:
          // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
          // initialFile: "assets/index.html",
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          initialSettings: settings,
          // contextMenu: contextMenu,
          // pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              // this.url = url.toString();
              // urlController.text = this.url;
            });
          },
          // onPermissionRequest: (controller, request) {
          //   return PermissionResponse(
          //       resources: request.resources,
          //       action: PermissionResponseAction.GRANT);
          // },
          // shouldOverrideUrlLoading:
          //     (controller, navigationAction) async {
          //   var uri = navigationAction.request.url!;
          //
          //   if (![
          //     "http",
          //     "https",
          //     "file",
          //     "chrome",
          //     "data",
          //     "javascript",
          //     "about"
          //   ].contains(uri.scheme)) {
          //     if (await canLaunchUrl(uri)) {
          //       // Launch the App
          //       await launchUrl(
          //         uri,
          //       );
          //       // and cancel the request
          //       return NavigationActionPolicy.CANCEL;
          //     }
          //   }
          //
          //   return NavigationActionPolicy.ALLOW;
          // },
          // onLoadStop: (controller, url) {
          //   pullToRefreshController?.endRefreshing();
          //   setState(() {
          //     this.url = url.toString();
          //     urlController.text = this.url;
          //   });
          // },
          // onReceivedError: (controller, request, error) {
          //   pullToRefreshController?.endRefreshing();
          // },
          // onProgressChanged: (controller, progress) {
          //   if (progress == 100) {
          //     pullToRefreshController?.endRefreshing();
          //   }
          //   setState(() {
          //     this.progress = progress / 100;
          //     urlController.text = this.url;
          //   });
          // },
          // onUpdateVisitedHistory: (controller, url, isReload) {
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
