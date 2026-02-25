import 'package:flutter/cupertino.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';

class PSImg extends StatelessWidget {
  final String name;
  final double? width;
  final double? height;
  final double? size;
  final BoxFit fit;

  const PSImg({
    super.key,
    required this.name,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    var p = "$name".image();
    return Image.asset(
      p,
      fit: fit,
      width: size ?? width,
      height: size ?? height,
    );
  }
}

DecorationImage PSDImg(String name, {BoxFit fit = BoxFit.fill}) {
  var p = "$name".image();
  return DecorationImage(image: AssetImage(p), fit: fit);
}

Offset getWidgetLocal(BuildContext context) {
  try {
    RenderBox pos = context.findRenderObject() as RenderBox;
    return pos.localToGlobal(Offset.zero);
  } catch (e) {
    return Offset.zero;
  }
}

String formatTimeHHmm(int s) {
  var res = "";

  int m = s ~/ 60;
  if (m > 9) {
    res += "$m:";
  } else if (m > 0) {
    res += "0$m:";
  } else {
    res += "00:";
  }

  s %= 60;

  if (s > 9) {
    res += s.toString();
  } else if (s > 0) {
    res += "0$s";
  } else {
    res += "00";
  }

  return res;
}

class PSBouncyImage extends StatefulWidget {
  final String imagePath; // 图片路径
  final double width; // 宽度
  final double height; // 高度
  final bool enableAnimation; // ✅ 是否启用动画

  const PSBouncyImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    this.enableAnimation = true, // 默认启用动画
  });

  @override
  State<PSBouncyImage> createState() => _PSBouncyImageState();
}

class _PSBouncyImageState extends State<PSBouncyImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // 呼吸节奏略快，Q弹自然
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scale = Tween(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PSBouncyImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 🔄 动态响应外部动画开关变化
    if (oldWidget.enableAnimation != widget.enableAnimation) {
      if (widget.enableAnimation) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 1.0; // 停止时恢复原始大小
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ❌ 如果动画关闭，直接返回静态图片
    if (!widget.enableAnimation) {
      return Image.asset(
        widget.imagePath.image(),
        width: widget.width,
        height: widget.height,
      );
    }

    // ✅ 启用动画时，应用缩放效果
    return ScaleTransition(
      scale: _scale,
      child: Image.asset(
        widget.imagePath.image(),
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

class PSAnimatedImageMove extends StatefulWidget {
  final String imageUrl;
  final bool isAnimationEnabled;
  final double ws;
  final double hs;
  final GlobalKey targetKey; // 目标组件的 key

  const PSAnimatedImageMove({
    Key? key,
    required this.imageUrl,
    required this.isAnimationEnabled,
    required this.ws,
    required this.hs,
    required this.targetKey,
  }) : super(key: key);

  @override
  _PSAnimatedImageMoveState createState() => _PSAnimatedImageMoveState();
}

class _PSAnimatedImageMoveState extends State<PSAnimatedImageMove>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // 缩放动画
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _offsetAnimation = AlwaysStoppedAnimation(Offset.zero);

    // 动画结束后让组件消失
    _controller.addStatusListener((status) {
      if (!mounted) return; // ✅ widget 已经销毁了就不继续
      if (status == AnimationStatus.completed) {
        setState(() {
          _visible = false;
        });
      }
    });

    if (widget.isAnimationEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimation();
      });
    }
  }

  void _startAnimation() {
    final RenderBox? targetBox =
        widget.targetKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? parentBox = context.findRenderObject() as RenderBox?;

    print('targetBox: $targetBox');
    print('parentBox: $parentBox');
    if (targetBox != null && parentBox != null) {
      final targetPosition = targetBox.localToGlobal(Offset.zero);
      final parentPosition = parentBox.localToGlobal(Offset.zero);
      final relativeOffset = targetPosition - parentPosition;

      _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: relativeOffset)
          .animate(
            CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
            ),
          );
      _controller.forward();
      'startAnimation'.log();
      print('Controller status: ${_controller.status}');
    }
  }

  @override
  void didUpdateWidget(covariant PSAnimatedImageMove oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimationEnabled && !_controller.isAnimating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _visible = true);
        _controller.reset();
        _startAnimation();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.ws,
              height: widget.hs,
              child: PSImg(name: widget.imageUrl),
            ),
          ),
        );
      },
    );
  }
}
