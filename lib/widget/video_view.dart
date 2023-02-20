import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 播放器组件
class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  const VideoView({Key? key, required this.url, this.cover = "", this.autoPlay = false, this.looping = false, this.aspectRatio = 16 / 9}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(videoPlayerController: _videoPlayerController, aspectRatio: widget.aspectRatio, autoPlay: widget.autoPlay, looping: widget.looping);
  }

  @override
  void dispose() {
    super.dispose();
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
}
