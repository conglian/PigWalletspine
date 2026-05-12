import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import '../PSHome/PSHome.dart';
import 'PSTBAEventTool.dart';

class PSInAppNotification {
  static final PSInAppNotification _instance = PSInAppNotification._internal();
  factory PSInAppNotification() => _instance;
  PSInAppNotification._internal();

  OverlayEntry? _overlayEntry;
  Timer? _timer;
  bool _isShowing = false;
  final Random _random = Random();

  // 可随机金额列表
  final List<int> _amounts = [100, 120, 150, 200];

  // 文案模板列表，使用 {amount} 占位符
  final List<Map<String, String>> _messages = [
    {'title': '🎉 PayPal Payout Success', 'content': 'Mary received \$ {amount} via PayPal successfully 💰'},
    {'title': '💸 Cash Out Completed', 'content': 'James just cashed out \$ {amount} to PayPal ✅'},
    {'title': '🎯 Another Winner Paid', 'content': 'Linda received \$ {amount} in her PayPal account'},
    {'title': '💰 Big Payout Alert', 'content': 'Robert successfully withdrew \$ {amount} via PayPal'},
    {'title': '🎉 Withdrawal Sent', 'content': 'Sarah just received \$ {amount} through PayPal'},
    {'title': '💸 PayPal Transfer Done', 'content': 'Michael cashed out \$ {amount} successfully'},
  ];

  int _currentIndex = 0;

  /// 初始化计时器
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      prefs.setBool('first_launch', false);
      _startTimer(_random.nextInt(2) + 1); // 测试用 1~2 分钟
    } else {
      _startTimer(_random.nextInt(6) + 5); // 5~10 分钟
    }
  }

  void _startTimer(int minutes) {
    _timer?.cancel();
    _timer = Timer(Duration(minutes: minutes), () {
      final msg = _messages[_currentIndex];

      // 随机金额替换 {amount} 占位符
      final amount = _amounts[_random.nextInt(_amounts.length)];
      final content = msg['content']!.replaceAll('{amount}', amount.toString());

      _showNotification(msg['title']!, content);

      // 下一个索引循环
      _currentIndex = (_currentIndex + 1) % _messages.length;

      // 下一条 5~10 分钟
      _startTimer(_random.nextInt(6) + 5);
    });
  }

  void dispose() {
    _timer?.cancel();
    _overlayEntry?.remove();
  }

  void _showNotification(String title, String content) {
    ps_event_fire('push_appin_p', {});

    if (_isShowing) return;
    _isShowing = true;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _NotificationWidget(
          title: title,
          content: content,
          onComplete: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
            _isShowing = false;
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = homeKey.currentContext;
      if (context != null) {
        Overlay.of(context)?.insert(_overlayEntry!);
      } else {
        _isShowing = false;
      }
    });
  }
}

// --- Notification Widget ---

class _NotificationWidget extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onComplete;
  const _NotificationWidget({required this.title, required this.content, required this.onComplete});

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation = Tween<double>(begin: -104, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        widget.onComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _animation.value),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 104,
              child: Stack(
                children: [
                  Positioned(
                    top: 28,
                    left: 7,
                    child: PSImg(
                      name: 'ps_inapp_notice_bg',
                      width: MediaQuery.of(context).size.width - 14,
                      height: 76,
                    ),
                  ),
                  Positioned(
                    right: 14.w,
                    top: 32,
                    child: PSImg(
                      name: 'ps_inapp_notice_icon',
                      width: 68,
                      height: 68,
                    ),
                  ),
                  Positioned(
                    left: 25.w,
                    top: 46,
                    child: PSImg(
                      name: 'ps_user_s_0',
                      width: 49,
                      height: 49,
                    ),
                  ),
                  Positioned(
                    left: 85.w,
                    top: 46,
                    height: 21,
                    child: PSText(
                      text: widget.title,
                      size: 18,
                      color: '#000000'.color(),
                      weight: FontWeight.w900,
                    ),
                  ),
                  Positioned(
                    left: 85.w,
                    top: 71,
                    child: SizedBox(
                      width: 227.w,
                      height: 14,
                      child: PSText(
                        text: widget.content,
                        size: 12,
                        color: '#152456'.color(),
                        weight: FontWeight.w600,
                        maxLines: 3,
                        align: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}