import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LookImagesTool {
  static lookImages({
    required List<String> listData,
    int? currentPage,
  }) async {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return LookImagesWidget(
            listData: listData,
            currentPage: currentPage,
          );
        });
  }
}

class LookImagesWidget extends StatefulWidget {
  final List<String> listData;
  final int? currentPage;

  const LookImagesWidget({
    super.key,
    required this.listData,
    this.currentPage,
  });

  @override
  State<LookImagesWidget> createState() => _LookImagesWidgetState();
}

class _LookImagesWidgetState extends State<LookImagesWidget> {
  List listData = [];
  late int currentPage;
  late int initialPage = 0;

  @override
  void initState() {
    listData = widget.listData;
    if (widget.currentPage == null) {
      initialPage = 0;
      currentPage = 0;
    } else {
      // initialPage = 0;
      currentPage = widget.currentPage ?? 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: PhotoViewGallery.builder(
                itemCount: listData.length,
                pageController: PageController(initialPage: currentPage),
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                builder: (_, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      listData[index],
                    ),
                  );
                },
              ),
            ),
          ),
          //图片张数指示器
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "${currentPage + 1}/${listData.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
