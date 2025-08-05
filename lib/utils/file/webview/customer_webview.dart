// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
//
// class CustomerWebView extends StatefulWidget {
//   final String url;
//
//   const CustomerWebView({super.key, required this.url});
//
//   @override
//   State<CustomerWebView> createState() => _CustomerWebViewState();
// }
//
// class _CustomerWebViewState extends State<CustomerWebView> {
//   late final WebViewController _controller;
//   @override
//   void initState() {
//
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) async{
//             // await EasyLoading.show(
//             //   // status: 'loading...',
//             //   maskType: EasyLoadingMaskType.black,
//             // );
//           },
//           onPageFinished: (String url) async{
//             // await EasyLoading.dismiss();
//           },
//           onHttpError: (HttpResponseError error) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: [SystemUiOverlay.bottom]);
//     return SafeArea(
//         child: Stack(
//       alignment: Alignment.topLeft,
//       children: [
//         WebViewWidget(controller: _controller),
//         GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             margin: const EdgeInsets.only(left: 16, top: 16),
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(22),
//               color: Colors.grey.withOpacity(0.3),
//             ),
//             child: const Icon(
//               Icons.navigate_before,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     ));
//   }
// }
