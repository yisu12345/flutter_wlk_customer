// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
//
// class CustomerPDFPage extends StatefulWidget {
//   final String filePath;
//   const CustomerPDFPage({
//     super.key,
//     required this.filePath,
//   });
//
//   @override
//   State<CustomerPDFPage> createState() => _CustomerPDFPageState();
// }
//
// class _CustomerPDFPageState extends State<CustomerPDFPage> {
//   final StreamController<String> _pageCountController =
//       StreamController<String>();
//   final Completer<PDFViewController> _pdfViewController =
//       Completer<PDFViewController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             PDF(
//               onPageChanged: (int? current, int? total) =>
//                   _pageCountController.add('${current! + 1} - $total'),
//               onViewCreated: (PDFViewController pdfViewController) async {
//                 _pdfViewController.complete(pdfViewController);
//                 final int currentPage =
//                     await pdfViewController.getCurrentPage() ?? 0;
//                 final int? pageCount = await pdfViewController.getPageCount();
//                 _pageCountController.add('${currentPage + 1} - $pageCount');
//               },
//             ).cachedFromUrl(
//               widget.filePath,
//               placeholder: (progress) => Center(child: Text('$progress %')),
//               errorWidget: (error) => Center(child: Text(error.toString())),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     margin: const EdgeInsets.only(left: 16, top: 16),
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(22),
//                       color: Colors.grey.withOpacity(0.3),
//                     ),
//                     child: const Icon(
//                       Icons.navigate_before,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(right: 16, top: 16),
//                   width: 88,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(22),
//                     color: Colors.grey.withOpacity(0.3),
//                   ),
//                   child: StreamBuilder<String>(
//                       stream: _pageCountController.stream,
//                       builder: (_, AsyncSnapshot<String> snapshot) {
//                         if (snapshot.hasData) {
//                           return Center(
//                             child: Text(snapshot.data!),
//                           );
//                         }
//                         return const SizedBox();
//                       }),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
