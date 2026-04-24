import 'dart:math';
import 'package:flutter/material.dart';

class PSMarqueeText extends StatefulWidget {
  const PSMarqueeText({
    Key? key,
    this.height = 30,
    this.speed = 40, // px/s
    this.gap = 40,
  }) : super(key: key);

  final double height;
  final double speed;
  final double gap;

  @override
  State<PSMarqueeText> createState() => _PSMarqueeTextState();
}

class _PSMarqueeTextState extends State<PSMarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _itemWidth1 = 0;
  double _itemWidth2 = 0;

  late String user1;
  late int money1;

  late String user2;
  late int money2;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    user1 = _randomUser();
    money1 = _randomMoney();

    user2 = _randomUser();
    money2 = _randomMoney();

    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  // Function to measure width after build
  void _measure() {
    final ctx1 = context.findRenderObject() as RenderBox?;
    final ctx2 = context.findRenderObject() as RenderBox?;

    if (ctx1 != null && ctx2 != null) {
      final w1 = ctx1.size.width;
      final w2 = ctx2.size.width;

      if (w1 != 0 && w1 != _itemWidth1) {
        setState(() {
          _itemWidth1 = w1;
        });
      }

      if (w2 != 0 && w2 != _itemWidth2) {
        setState(() {
          _itemWidth2 = w2;
        });
      }

      if (_itemWidth1 > 0 && _itemWidth2 > 0) {
        final totalWidth = _itemWidth1 + _itemWidth2 + widget.gap;
        final seconds = (totalWidth / widget.speed).ceil();

        _controller.duration = Duration(seconds: seconds);
        _controller
          ..reset()
          ..repeat();
      }
    }
  }

  // Function to update data after build is completed
  void _updateData() {
    setState(() {
      user1 = user2;
      money1 = money2;

      user2 = _randomUser();
      money2 = _randomMoney();
    });
  }

  String _randomUser() {
    int start = _random.nextInt(90) + 10;
    int end = _random.nextInt(9000) + 1000;
    return "$start****$end";
  }

  int _randomMoney() {
    const list = [100, 150, 200];
    return list[_random.nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ClipRect(
        child: _itemWidth1 == 0 || _itemWidth2 == 0
            ? _buildSingle(user1, money1, user2, money2)
            : AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final totalWidth = _itemWidth1 + _itemWidth2 + widget.gap;
            final offset = totalWidth * _controller.value;

            // 在动画接近结束时更新数据
            if (_controller.value >= 0.99) {
              // 延迟调用来避免在构建中直接调用 setState()
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateData();
              });
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Transform.translate(
                offset: Offset(-offset, 0),
                child: Transform.scale(
                  scale: 0.8, // 保持0.8倍缩放
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSingle(user1, money1, user2, money2),
                      SizedBox(width: widget.gap),
                      _buildSingle(user2, money2, user1, money1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Build single content with parameters
  Widget _buildSingle(String user1, int money1, String user2, int money2) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _richText(user1, money1),
        SizedBox(width: widget.gap),
        _richText(user2, money2),
      ],
    );
  }

  // Text with stroke and fill color
  Widget _richText(String user, int money) {
    return Stack(
      children: [
        // Stroke Text
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Black_mianfeiziti',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = const Color(0xFF600E0E),
            ),
            children: [
              TextSpan(text: 'Congrats! User $user just cashed out '),
              TextSpan(text: '\$$money!'),
            ],
          ),
        ),

        // Filled Text
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Black_mianfeiziti',
              color: Colors.white,
            ),
            children: [
              TextSpan(text: 'Congrats! User $user just cashed out '),
              TextSpan(
                text: '\$$money!',
                style: const TextStyle(
                  color: Color(0xFFFFFF00),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}