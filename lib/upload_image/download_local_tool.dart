import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadLocalTool {
  /// 拿到存储路径
  /// 使用getTemporaryDirectory()方法可以获取应用程序的临时目录，该目录用于存储应用程序的临时数据。这个目录在应用程序退出后会被清空
  Future<String> getTemporaryDirectoryString() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  ///  使用getApplicationDocumentsDirectory()方法可以获取应用程序的文档目录，该目录用于存储应用程序的私有数据。
  Future<String> getApplicationDocumentsDirectoryString() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///  使用getExternalStorageDirectory()方法可以获取设备的外部存储目录，该目录用于存储应用程序的公共数据。需要注意的是，在某些设备上，外部存储目录可能是不可用的。
  Future<String> getExternalStorageDirectoryString() async {
    final directory = await getExternalStorageDirectory();
    return directory?.path ?? "";
  }

  /// 创建对文件位置的引用
  Future<File> localFile(String fileName) async {
    final path = await getApplicationDocumentsDirectoryString();
    return File('$path/$fileName');
  }

  ///save
   Future<dynamic> saveNetworkVideoFile({
    required String fileName,
    required String fileUrl,
  }) async {
    final path = await getApplicationDocumentsDirectoryString();
    String savePath = "$path/$fileName ";
    // String fileUrl =
    //     "https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/video/ForBiggerBlazes.mp4";
    //
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      print("${(count / total * 100).toStringAsFixed(0)}%");
    });
    final result = await ImageGallerySaver.saveFile(savePath);
    return result;
    // print(result);
  }

  ///save
  Future<dynamic> saveNetworkVideoFileExternalStorageDirectory({
    required String fileName,
    required String fileUrl,
  }) async {
    final path = await getApplicationDocumentsDirectoryString();
    String savePath = "$path/$fileName ";
    // String fileUrl =
    //     "https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/video/ForBiggerBlazes.mp4";
    //
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      print("${(count / total * 100).toStringAsFixed(0)}%");
    });
    final result = await ImageGallerySaver.saveFile(savePath);
    return result;
    // print(result);
  }




// // 将数据写入文件
//   Future<File> writeCounter(int counter) async {
//     final file = await _localFile;
//     // Write the file
//     return file.writeAsString('$counter');
//   }
//
// // 从文件中读取数据
//   Future<int> readCounter() async {
//     try {
//       final file = await _localFile;
//       // Read the file
//       String contents = await file.readAsString();
//
//       return int.parse(contents);
//     } catch (e) {
//       // If we encounter an error, return 0
//       return 0;
//     }
//   }
}
