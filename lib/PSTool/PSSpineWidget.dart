import 'package:flutter/material.dart';
import 'package:spine_flutter/spine_flutter.dart' as runtime;
import 'package:spine_flutter/spine_widget.dart' as spine;

/// 先完成资源加载，再挂载 Spine，页面快速切换时释放迟到的资源。
/// 保留项目原有动画与控制器，避免旧版本 Spine 加载后更新已销毁的页面。
class PSSpineWidget extends StatefulWidget {
  final String atlas;
  final String skeleton;
  final spine.SpineWidgetController controller;
  final BoxFit? fit;
  final Alignment? alignment;
  PSSpineWidget.fromAsset(
    this.atlas,
    this.skeleton,
    this.controller, {
    Key? key,
    this.fit,
    this.alignment,
  }) : super(key: key ?? ValueKey((atlas, skeleton, controller)));

  @override
  State<PSSpineWidget> createState() => _PSSpineWidgetState();
}

class _PSSpineWidgetState extends State<PSSpineWidget> {
  runtime.SkeletonDrawable? _drawable;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final drawable = await runtime.SkeletonDrawable.fromAsset(
        widget.atlas,
        widget.skeleton,
      );
      if (!mounted) {
        drawable.dispose();
        return;
      }
      setState(() => _drawable = drawable);
    } catch (error, stack) {
      if (mounted)
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'PigWallet Spine assets',
          ),
        );
    }
  }

  @override
  void dispose() {
    _drawable?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _drawable == null
      ? const SizedBox()
      : spine.SpineWidget.fromDrawable(
          _drawable!,
          widget.controller,
          fit: widget.fit,
          alignment: widget.alignment,
        );
}
