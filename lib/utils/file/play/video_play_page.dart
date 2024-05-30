import 'package:flutter/material.dart';
import 'package:flutter_wlk_customer/utils/file/video/lib/chewie.dart';
import 'package:video_player/video_player.dart';




class VideoPlayPage extends StatefulWidget {
  final String? videoUrl;
  const VideoPlayPage({super.key, this.videoUrl});

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  var videoController = VideoPlayerController.network("");
  var chewieController;
//监听视频是否在播放
  bool isPlaying = false;
//视频地址 https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4
//   String videoUrl =
//       "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
//   String videoUrl =
//       "http://static.dongmenshijing.com/upload/20230720/cf742bbf-8a96-46d5-b187-edeffa168556.mp4";

  @override
  void initState() {
    // Uri url = Uri.parse(videoUrl);
    // videoController = VideoPlayerController.networkUrl(url)
    //   ..initialize().then((value) {
    //     setState(() {});
    //   });
    // videoController = VideoPlayerController.network(
    //   videoUrl,
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // )..initialize().then((value) {
    //     setState(() {});
    //   });
    // videoController.addListener(() {
    //   setState(() {});
    // });
    initVideoController();
    super.initState();
  }

  ///初始化
  initVideoController({String? url}) {
    videoController = VideoPlayerController.network(
      widget.videoUrl ?? "",
    )..initialize().then((_) {
        setState(() {
          chewieController = ChewieController(
            // autoInitialize: true,
            fullScreenByDefault: true,
            videoPlayerController: videoController,
            allowFullScreen: true,
            // aspectRatio: MediaQuery.of(context).size.height /
            //     MediaQuery.of(context).size.width,
            autoPlay: true,
            looping: false,
          );
        });
      });
    videoController.addListener(() {
      setState(() {});
    });

    setState(() {});
  }

  @override
  void dispose() {
    videoController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return chewieController == null
        ? Container()
        : Chewie(
            controller: chewieController,
          );
  }
}
