import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wlk_customer/utils/customer.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'package:get/get.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:images_picker/images_picker.dart';
// import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ossUtil.dart';

class UploadImages extends StatefulWidget {
  final Function? chooseImages; // List<String>
  final int? max; //最大照片数量
  final int? hNumber; //一排最大几个
  final bool? onlyShow; //仅展示，不操作
  final BoxFit? fit;
  final List<String>? imagesList; //图片数组
  final String oSSAccessKeyId;
  final String policy;
  final String callback;
  final String signature;
  final String ossDirectory;
  final String ossHost;
  final Widget carmaWidget;
  final Function? oneTap; //点击的哪一个
  final Function? deleteTap; //删除一个后

  const UploadImages({
    super.key,
    this.chooseImages,
    this.max = 9,
    this.onlyShow = false,
    this.imagesList,
    required this.oSSAccessKeyId,
    required this.policy,
    required this.callback,
    required this.signature,
    required this.ossDirectory,
    required this.ossHost,
    required this.carmaWidget,
    this.hNumber = 3,
    this.fit,
    this.oneTap,
    this.deleteTap,
  });

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<String> imagesList = [];
  bool isMax = false; //是否达到最大值

  @override
  void initState() {
    // print("widget.maxwidget.max ============ ${widget.max}");
    if (widget.imagesList != null) {
      imagesList = widget.imagesList ?? [];
    }
    super.initState();
  }

  ///数组的数量
  setImageListLength() {
    // print("widget.maxwidget.max ============ ${widget.max}");
    // print("imagesList.length ============ ${imagesList.length}");
    if (imagesList.length < (widget.max?.toInt() ?? 9)) {
      isMax = false;
      return imagesList.length + 1;
    } else if (imagesList.length == (widget.max?.toInt() ?? 9)) {
      isMax = true;
      return imagesList.length;
    } else {
      isMax = true;
      return 9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.only(top: 0),
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: setImageListLength(),
      itemBuilder: (_, int index) {
        if (isMax == true) {
          String? imageUrl = imagesList[index];
          return cellDeleteWidget(
            index: index,
            child: GestureDetector(
              onTap: () => widget.oneTap?.call(index),
              child: imageNetworkWidget(
                imageUrl: imageUrl,
                index: index,
              ),
            ),
          );
        } else {
          if (index == setImageListLength() - 1) {
            return widget.onlyShow == true
                ? const SizedBox()
                : uploadWidget(context);
          } else {
            String? imageUrl = imagesList[index];
            return cellDeleteWidget(
              index: index,
              child: imageNetworkWidget(
                imageUrl: imageUrl,
                index: index,
              ),
            );
          }
        }
      },
      mainAxisSpacing: 15,
      crossAxisSpacing: 8,
    );
  }

  Widget imageNetworkWidget({
    required String imageUrl,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => widget.oneTap?.call(index),
      child: CustomerImagesNetworking(
        imageUrl: imageUrl,
        fit: widget.fit ?? BoxFit.cover,
      ),
    );
  }

  ///cell 总样式
  Widget cellWidget({required Widget child}) {
    return SizedBox(
      key: Key(cellKeyString()),
      width: (Get.width - 32 - 32) / (widget.hNumber ?? 3),
      height: (Get.width - 32 - 32) / (widget.hNumber ?? 3),
      child: child,
    );
  }

  ///cell key 随机数+时间
  String cellKeyString({String? string}) {
    var random = Random();
    int randomNumber = random.nextInt(10000); // 生成0到10000000000000之间的随机整数
    return '$randomNumber + $string + ${DateTime.now().toString()}';
  }

  ///有删除样式的cell
  Widget cellDeleteWidget({
    required Widget child,
    required int index,
  }) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        cellWidget(child: child),
        widget.onlyShow == true
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  imagesList.removeAt(index);
                  widget.deleteTap?.call(imagesList);
                  setState(() {});
                },
                child: ClipOval(
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    color: Colors.grey.withOpacity(0.5),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 25.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  ///上传的Widget
  Widget uploadWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (Platform.isIOS) {
          await chooseCamera(
            context: context,
            max: widget.max,
          );
        } else {
          bool b = await requestPermission(context);
          if (b == true) {
            await chooseCamera(
              context: context,
              max: widget.max,
            );
          }
        }
      },
      child: cellWidget(
        child: widget.carmaWidget,
      ),
    );
  }

  /// 动态申请权限，需要区分android和ios，很多时候它两配置权限时各自的名称不同
  /// 此处以保存图片需要的配置为例
  Future<bool> requestPermission(context) async {
    late PermissionStatus status;
    // 1、读取系统权限的弹框
    if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      status = await Permission.camera.request();
    }
    // 2、假如你点not allow后，下次点击不会在出现系统权限的弹框（系统权限的弹框只会出现一次），
    // 这时候需要你自己写一个弹框，然后去打开app权限的页面

    if (status != PermissionStatus.granted) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text('您需要去打开权限'),
              content: const Text('请打开您的相机或者相册权限'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    // 打开手机上该app权限的页面
                    openAppSettings();
                  },
                ),
              ],
            );
          });
    } else {
      return true;
    }
    return false;
  }

  ///
  Future<void> chooseCamera({
    required BuildContext context,
    int? max,
  }) async {
    //
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoActionSheet(
            title: const Text('上传图片'),
            message: Text('请选择上传方式\n相册最多${max ?? 9}张'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('拍照上传'),
                onPressed: () {
                  openCamera();
                  Get.back();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('相册'),
                onPressed: () {
                  openGallery();
                  Get.back();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text('取消'),
              onPressed: () {
                Get.back();
              },
            ),
          );
        });
  }

  //
  openCamera() async {
    List<Media>? images =  await ImagesPicker.openCamera(
      pickType: PickType.video,
      maxTime: 15,
      maxSize: 1,
    );

    // XFile? file = await ImagePicker().pickImage(
    //   source: ImageSource.camera,
    // );
    if (images?.isEmpty == true) {
      Get.back();
    } else {
      Media? media = images?.first;
      String imgPath = await saveNetworkImgGallery(
        media?.path ?? '',
      );
      imagesList.add(imgPath);
      widget.chooseImages?.call(imagesList);
      setState(() {});
    }
  }

  openGallery() async {
    int number = (widget.max ?? 9) - imagesList.length;
    List<Media>? images =
        await ImagesPicker.pick(count: number, pickType: PickType.image);
    List<String> list = [];
    // List<XFile>? images = await ImagePicker().pickMultiImage(limit: number,);
    if (images?.isEmpty != true) {
      for (var element in images!) {
        String path = await saveNetworkImgGallery(
          element.path,
        );
        list.add(path);
      }
      imagesList.addAll(list);
      widget.chooseImages?.call(imagesList);
      setState(() {});
    } else {
      ToastUtils.showToast(msg: "请选择图片");
    }
  }

  // 保存网络图片
  // Future<String> saveNetworkImg(XFile file) async {
  //   // print("file.path ===== ${file.path}");
  //   String string = await UploadOss.upload(
  //     file.path,
  //     fileType: "jpg",
  //     oSSAccessKeyId: widget.oSSAccessKeyId,
  //     ossHost: widget.ossHost,
  //     ossDirectory: widget.ossDirectory,
  //     policy: widget.policy,
  //     callback: widget.callback,
  //     signature: widget.signature,
  //   );
  //   // print("Gallery ===string== $string");
  //   return string;
  // }

  // 保存网络图片
  Future<String> saveNetworkImgGallery(String path) async {
    String string = await UploadOss.upload(
      path,
      fileType: "jpg",
      oSSAccessKeyId: widget.oSSAccessKeyId,
      ossHost: widget.ossHost,
      ossDirectory: widget.ossDirectory,
      policy: widget.policy,
      callback: widget.callback,
      signature: widget.signature,
    );
    return string;
  }
}
