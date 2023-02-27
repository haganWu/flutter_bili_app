import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/hi_video_controls.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

/// 播放器组件
class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget overlayUI;

  const VideoView(
      {Key? key, required this.url, this.cover = "", this.autoPlay = true, this.looping = false, this.aspectRatio = 16 / 9, required this.overlayUI})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  // 视频封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(url: widget.cover),
      );

  // 进度条颜色
  get _progressColors => ChewieProgressColors(playedColor: primary, handleColor: primary, backgroundColor: Colors.grey, bufferedColor: primary[50]!);

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        // 视频封面
        placeholder: _placeholder,
        materialProgressColors: _progressColors,
        // 静音播放
        allowMuting: false,
        //是否显式控制播放进度
        allowPlaybackSpeedChanging: false,
        customControls: HiVideoControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,
          bottomGradient: blackLinearGradient(fromTop: false),
          overlayUI: widget.overlayUI,
        ));
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.removeListener(_fullScreenListener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      // 横屏
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
